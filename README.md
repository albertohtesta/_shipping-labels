Solución al proyecto Multi-carrier Shipping Labels API
Plataformas
Para la realización de este proyecto se utilizaron las siguientes plataformas:
Linux Ubuntu - sistema operativo
Ruby 3.0.1
Rails  6.1.4.4
Github - repositorio de código en línea
Bootstrap - estilos css
Postman - para probar las apis

Idioma
Se utilizó el idioma inglés para la parte del código (nombre de clases, nombre de acciones, procedimientos, commits de github, etc.) por su facilidad de uso y costumbre personal, y por la ventaja de que al trabajar con equipos internacionales es un idioma neutral.
Se utilizó el español para las páginas de usuario final y la documentación

Gems
rspec-rails - para pruebas unitarias y de request
shoulda-matchers - para pruebas unitarias de entidades y relaciones
rest-client - cliente rest de la API del carrier, que envía los datos de los shippings para obtener las urls de las etiquetas, id del response, tracking number y shipment id
down - descarga los pdfs de las etiquetas en base a los urls que envía el API del carrier
rubyzip - para crear archivos zips de las etiquetas en pdf
byebug - para depuración del código

Public folder
carpetas: 
pdfs (guarda los archivos pdfs de las etiquetas por id solicitud-id de shipping
zips (guarda los archivos zip de las etiquetas de cada solicitud por id de solicitud)

DB seeds
se borran todas las bases de datos y se genera el carrier: fake_carrier

models migration
rails g model Carrier name:string endpoint:string token:string
rails g model Solicitude fecha:date status:string tracking_number:string
rails g model Shipping carrier:belongs_to solicitude:belongs_to name_from:string street_from:string city_from:string province_from:string postal_code_from:string countr_code_from:string name_to:string street_to:string city_to:string province_to:string postal_code_to:string countr_code_to:string length:integer width:integer height:integer dimensions_unit:string weight:integer weight_unit:string status:string shipment_id:string label_url:string id_response:string tracking_number:string

models

class Carrier    
    has_many :shippings
class Solicitude 
    has_many :shippings
class Shipping
    belongs_to :solicitude
    belongs_to :carrier
.gitignore

/public/pdfs
/public/zips

Servicio interno
modulo: Carrierservice
clase: SendSolicitude
Hace la petición al carrier con la colección de Shippings

Librería interna
Se configuró en :
config/ application.rb:
para indicar dónde estarán los módulos que usará el sistema.
	config.autoload_paths += %W(#{config.root}/lib)
Modulo Interfaceable - este módulo es usado por los Jobs como soporte para realizar las siguientes funciones:
getResponse : formatea y envía los shippings al carrier y graba el status de cada shipping.
downloadPdf : descarga el archivo pdf de cada shipping
Flujo de la Solicitud
Al recibir la solicitud en nuestra API del cliente REST pasa al status: ‘pending’
Al grabarse la solicitud pasa al estatus: ‘processing’
se ejecutan 3 jobs:
SolicitudeJob (al momento de grabarse la solicitud)
SolicitudeSecondTryJob programado para ejecutarse 1 minuto después del primer Job para los shippings que no pudieron procesarse en el primer job en virtud de no recibir respuesta del carrier.
  SolicitudeThirdTryJob programado para ejecutarse 1 minuto después del segundo Job para los shippings que no pudieron procesarse en el 2o. job en virtud de no recibir respuesta del carrier.
Al terminar los 3 jobs si faltó algún shipping de procesamiento se marca el estatus de la solicitud como: ‘error’, ya que fue el fin de los intentos por alcanzar el server.
En este punto los pdfs de las etiquetas ya están descargados en la carpeta pública pdfs
La solicitud es consultada en nuestra API, si la solicitud existe y no está marcada como error, el estatus se indica cómo ‘completed’, se crea el archivo zip  y se devuelve en la respuesta el status y la liga para descargar el  archivo zip
	{"status":"completed",
"url":"http://localhost:3000/api/v1/download_pdf?solicitud_id=16" }
     -	Con la liga generada en el paso anterior y si la solicitud existe, nuestra API permite 
descargar el archivo zip

JOBS
Se utilizaron los Active Job de Rails, en producción se recomienda usar Sidekiq como background processing 

TEST
Se siguió un enfoque de code a little test a little
se crearon:
unit test - básicamente se hicieron test para validar la estructura de tablas, modelos y relaciones entre los modelos
request test  - se validaron cada una de las 3 peticiones de la app:
Solicitar la generación de las etiquetas
Consultar el estado de la generación de las etiquetas
Generación del archivo ZIP con las etiquetas

PÁGINAS WEB
Listado de las solicitudes:


Listado de los shippings de una solicitud:


Listado de Carriers


Consulta de Carriers


Edición de Carrier


Alta



Validaciones



Observaciones finales
Los 3 jobs programados en intervalos de un minuto, es una estrategia que dependerá de la calidad del servicio del carrier y dependiendo de esto se podrá utilizar otra estrategia.
Se usó Active Job de Rails por su facilidad de uso, este no debería usarse en producción.
Se usó un CDN para para servir bootstrap, en producción es mejor integrar bootstrap en la aplicación.
Se podría haber usado Active Storage, para asociar los archivos pdfs y zips, pero no se decidió no hacerlo, porque la app, se resolvió así y no se tuvo complicación al hacerlo y no fue completamente necesario.

