# Lädt Tageswerte aller DWD-Stationen und speichert die Extremtage in
# daten/d_extremtage_de.RData. Wird bei Bedarf von Hand ausgeführt.

# Pakete
library(rdwd)
library(mirai)
library(tidyverse)

# Parallele ausführung
daemons(parallel::detectCores() - 1)
everywhere({
  library(rdwd)
  library(tidyverse)
})

# Meta Index laden
data(metaIndex, package = "rdwd")

# Einlesen
ergebnisse <- metaIndex |>
  filter(res == "daily", var == "kl", hasfile) |>
  pull('Stationsname') |>
  unique() |>
  map(
    in_parallel(function(name) {
      tryCatch(
        suppressMessages(
          selectDWD(name, res = "daily", var = "kl", per = "hr") |>
            dataDWD() |>
            bind_rows() |>
            select(
              station = STATIONS_ID,
              datum = MESS_DATUM,
              tmin = TNK,
              tmax = TXK
            ) |>
            distinct(datum, .keep_all = TRUE) |>
            filter(tmin >= 20 | tmax >= 30)
        ),
        error = function(e) tibble(name = name, fehler = conditionMessage(e))
      )
    }),
    .progress = TRUE
  ) |>
  bind_rows()

# Split
d_extremtage_de <- ergebnisse |>
  filter(is.na(fehler)) |>
  select(-name, -fehler)
d_extremtage_fehler <- ergebnisse |> drop_na(fehler) |> select(name, fehler)

# Check
stopifnot(
  d_extremtage_de |> count(station, datum) |> filter(n > 1) |> nrow() == 0
)

# Save
save(d_extremtage_de, file = "daten/d_extremtage_de.RData")
