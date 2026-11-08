
import csv
import os
import sys
import time
from pathlib import Path
from decimal import Decimal, InvalidOperation
from datetime import date

import psycopg


# --------------------------------------------------
# CONFIGURACIÓN DE RUTAS Y COLUMNAS
# --------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent

CSV_ORIGEN = BASE_DIR / "datos" / "precios-autos-nuevos-mexico.csv"
CSV_RECHAZOS = BASE_DIR / "datos" / "rechazados" / "rechazos_catalogo.csv"

COLUMNAS = [
    "marca",
    "modelo",
    "version",
    "anio",
    "precio_mxn",
    "transmision",
    "motor",
    "potencia_hp",
    "rendimiento_km_l",
    "bolsas_aire",
    "frenado_autonomo",
    "fuente",
    "url",
    "fecha_verificacion",
]

COLUMNAS_SQL = [
    "marca",
    "modelo",
    "version",
    "anio",
    "precioReferencia",
    "transmision",
    "motor",
    "potenciaHP",
    "rendimientoKmL",
    "bolsasAire",
    "frenadoAutonomo",
    "fuente",
    "url",
    "fechaVerificacion",
]


# --------------------------------------------------
# FUNCIONES DE VALIDACIÓN
# --------------------------------------------------

def texto(row, campo, obligatorio=False, maximo=None):
    valor = row.get(campo)

    if valor is None:
        valor = ""

    valor = valor.strip()

    if obligatorio and not valor:
        raise ValueError(f"{campo}: el campo es obligatorio")

    if maximo is not None and len(valor) > maximo:
        raise ValueError(
            f"{campo}: excede la longitud máxima de {maximo}"
        )

    return valor or None


def entero(valor, campo, obligatorio=False, minimo=None, maximo=None):
    if valor is None or not valor.strip():
        if obligatorio:
            raise ValueError(f"{campo}: el campo es obligatorio")
        return None

    try:
        resultado = int(valor)
    except ValueError:
        raise ValueError(f"{campo}: debe ser un número entero")

    if minimo is not None and resultado < minimo:
        raise ValueError(f"{campo}: debe ser mayor o igual a {minimo}")

    if maximo is not None and resultado > maximo:
        raise ValueError(f"{campo}: debe ser menor o igual a {maximo}")

    return resultado


def decimal_positivo(valor, campo, obligatorio=False, maximo=None):
    if valor is None or not valor.strip():
        if obligatorio:
            raise ValueError(f"{campo}: el campo es obligatorio")
        return None

    try:
        resultado = Decimal(valor)
    except InvalidOperation:
        raise ValueError(f"{campo}: formato decimal inválido")

    if not resultado.is_finite() or resultado <= 0:
        raise ValueError(f"{campo}: debe ser un número positivo")

    if resultado.as_tuple().exponent < -2:
        raise ValueError(f"{campo}: admite máximo dos decimales")

    if maximo is not None and resultado > maximo:
        raise ValueError(f"{campo}: excede el valor máximo permitido")

    return resultado


def booleano(valor, campo):
    if valor is None or not valor.strip():
        return None

    valor = valor.strip().lower()

    if valor in ("true", "1", "si", "sí", "yes"):
        return True

    if valor in ("false", "0", "no"):
        return False

    raise ValueError(f"{campo}: valor booleano inválido")


def validar_fila(row):
    marca = texto(row, "marca", True, 40)
    modelo = texto(row, "modelo", True, 60)
    version = texto(row, "version", True, 80)

    anio = entero(
        row.get("anio"), "anio",
        minimo=1980, maximo=2100
    )

    precio = decimal_positivo(
        row.get("precio_mxn"),
        "precio_mxn",
        obligatorio=True,
        maximo=Decimal("9999999999.99")
    )

    transmision = texto(row, "transmision", maximo=30)
    motor = texto(row, "motor")

    potencia = entero(
        row.get("potencia_hp"), "potencia_hp",
        minimo=1, maximo=32767
    )

    rendimiento = decimal_positivo(
        row.get("rendimiento_km_l"),
        "rendimiento_km_l",
        maximo=Decimal("999.99")
    )

    bolsas = entero(
        row.get("bolsas_aire"), "bolsas_aire",
        minimo=0, maximo=32767
    )

    frenado = booleano(
        row.get("frenado_autonomo"),
        "frenado_autonomo"
    )

    fuente = texto(row, "fuente", True)
    url = texto(row, "url", True)

    fecha_texto = texto(
        row, "fecha_verificacion", True
    )

    try:
        fecha = date.fromisoformat(fecha_texto)
    except ValueError:
        raise ValueError(
            "fecha_verificacion: debe tener formato YYYY-MM-DD"
        )

    return (
        marca,
        modelo,
        version,
        anio,
        precio,
        transmision,
        motor,
        potencia,
        rendimiento,
        bolsas,
        frenado,
        fuente,
        url,
        fecha,
    )


# --------------------------------------------------
# LECTURA Y VALIDACIÓN DEL CSV
# --------------------------------------------------

def leer_csv():
    validos = []
    rechazados = []
    claves_vistas = set()

    if not CSV_ORIGEN.exists():
        raise FileNotFoundError(
            f"No se encontró el archivo: {CSV_ORIGEN}"
        )

    with CSV_ORIGEN.open(
        "r", encoding="utf-8-sig", newline=""
    ) as archivo:

        lector = csv.DictReader(archivo)

        if lector.fieldnames != COLUMNAS:
            raise ValueError(
                "Los encabezados del CSV no coinciden "
                "con la estructura esperada."
            )

        for numero_fila, row in enumerate(lector, start=2):
            try:
                if None in row:
                    raise ValueError(
                        "La fila contiene columnas adicionales"
                    )

                datos = validar_fila(row)

                # La clave natural incluye año, incluso si es NULL.
                clave = (
                    datos[0].casefold(),
                    datos[1].casefold(),
                    datos[2].casefold(),
                    datos[3],
                )

                if clave in claves_vistas:
                    raise ValueError(
                        "Registro duplicado dentro del CSV"
                    )

                claves_vistas.add(clave)
                validos.append(datos)

            except (ValueError, TypeError) as error:
                rechazados.append({
                    "fila": numero_fila,
                    "motivo": str(error),
                    **{
                        columna: row.get(columna, "")
                        for columna in COLUMNAS
                    },
                })

    return validos, rechazados


# --------------------------------------------------
# REGISTRO DE RECHAZOS
# --------------------------------------------------

def guardar_rechazos(rechazados):
    CSV_RECHAZOS.parent.mkdir(
        parents=True, exist_ok=True
    )

    encabezados = ["fila", "motivo"] + COLUMNAS

    with CSV_RECHAZOS.open(
        "w", encoding="utf-8-sig", newline=""
    ) as archivo:

        escritor = csv.DictWriter(
            archivo, fieldnames=encabezados
        )

        escritor.writeheader()
        escritor.writerows(rechazados)


# --------------------------------------------------
# CARGA MASIVA Y TRANSACCIONAL
# --------------------------------------------------

def cargar_datos(registros):
    if not registros:
        return 0, 0

    with psycopg.connect(
        host=os.environ["DB_HOST"],
        port=os.environ["DB_PORT"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    ) as conexion:

        with conexion.transaction():

            with conexion.cursor() as cursor:

                cursor.execute("""
                    CREATE TEMP TABLE carga_catalogo (
                        marca VARCHAR(40) NOT NULL,
                        modelo VARCHAR(60) NOT NULL,
                        version VARCHAR(80) NOT NULL,
                        anio SMALLINT,
                        precioReferencia DECIMAL(12,2) NOT NULL,
                        transmision VARCHAR(30),
                        motor TEXT,
                        potenciaHP SMALLINT,
                        rendimientoKmL DECIMAL(5,2),
                        bolsasAire SMALLINT,
                        frenadoAutonomo BOOLEAN,
                        fuente TEXT NOT NULL,
                        url TEXT NOT NULL,
                        fechaVerificacion DATE NOT NULL
                    ) ON COMMIT DROP;
                """)

                columnas = ", ".join(COLUMNAS_SQL)

                # COPY realiza la carga masiva hacia la tabla temporal.
                with cursor.copy(
                    f"COPY carga_catalogo ({columnas}) FROM STDIN"
                ) as copia:

                    for registro in registros:
                        copia.write_row(registro)

                cursor.execute("""
                    INSERT INTO public.catalogoversion (
                        marca,
                        modelo,
                        version,
                        anio,
                        precioReferencia,
                        transmision,
                        motor,
                        potenciaHP,
                        rendimientoKmL,
                        bolsasAire,
                        frenadoAutonomo,
                        fuente,
                        url,
                        fechaVerificacion
                    )
                    SELECT
                        s.marca,
                        s.modelo,
                        s.version,
                        s.anio,
                        s.precioReferencia,
                        s.transmision,
                        s.motor,
                        s.potenciaHP,
                        s.rendimientoKmL,
                        s.bolsasAire,
                        s.frenadoAutonomo,
                        s.fuente,
                        s.url,
                        s.fechaVerificacion
                    FROM carga_catalogo s
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM public.catalogoversion t
                        WHERE
                            lower(t.marca) = lower(s.marca)
                            AND lower(t.modelo) = lower(s.modelo)
                            AND lower(t.version) = lower(s.version)
                            AND t.anio IS NOT DISTINCT FROM s.anio
                    )
                    RETURNING idcatalogo;
                """)

                insertados = len(cursor.fetchall())
                ya_existentes = len(registros) - insertados

        return insertados, ya_existentes


# --------------------------------------------------
# PROGRAMA PRINCIPAL
# --------------------------------------------------

def main():
    inicio = time.perf_counter()

    try:
        validos, rechazados = leer_csv()

        guardar_rechazos(rechazados)

        insertados, existentes = cargar_datos(validos)

        duracion = time.perf_counter() - inicio

        print("\n========== RESULTADO DE CARGA ==========")
        print(f"Tabla: catalogoversion")
        print(f"Registros válidos: {len(validos)}")
        print(f"Registros insertados: {insertados}")
        print(f"Registros ya existentes: {existentes}")
        print(f"Registros rechazados: {len(rechazados)}")
        print(f"Tiempo de ejecución: {duracion:.3f} segundos")
        print(f"Archivo de rechazos: {CSV_RECHAZOS}")
        print("Estado: CARGA FINALIZADA")
        print("========================================\n")

    except Exception as error:
        print("\nERROR: La carga no pudo completarse.")
        print(f"Motivo: {error}")
        print("La transacción fue revertida si ya había comenzado.")
        sys.exit(1)


if __name__ == "__main__":
    main()
