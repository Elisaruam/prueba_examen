
library(httr)
library(jsonlite)
library(tibble)

# API key
apikey <- "fdc68bb4abbb41958c75a7bd78310f81"

# URL base y endpoint de la API
url_base <- "https://newsapi.org"
endpoint <- "/v2/everything"

# Parámetros de la solicitud
params <- list(
  q = "bank",
  from = "2023-05-01",
  to = "2023-05-15",
  apiKey = apikey
)

# Construir la URL completa
url <- paste0(url_base, endpoint)

# Realizar la solicitud GET
response <- GET(url, query = params)

# Verificar el código de estado de la respuesta
if (http_status(response)$category == "Success") {
  # Obtener el contenido de la respuesta
  content <- content(response, as = "text", encoding = "UTF-8")
  
  # Convertir el contenido JSON a un tibble
  data_tibble <- fromJSON(content)
  data_tibble <- as_tibble(data_tibble)
  
  # Obtener la fuente con más noticias
  top_source <- data_tibble$source.name[which.max(data_tibble$source.name)]
  
  if (!is.na(top_source)) {
    cat("La fuente con más noticias relacionadas al contenido 'bank' es:", top_source)
  } else {
    cat("No se encontraron noticias para el contenido especificado.")
  }
} else {
  cat("Error en la solicitud GET:", http_status(response)$reason)
}
