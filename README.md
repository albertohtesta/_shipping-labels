<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
	<meta name="generator" content="LibreOffice 7.2.4.1 (Linux)"/>
	<meta name="author" content="alberto hernandez testa"/>
	<meta name="created" content="2022-01-31T14:16:00"/>
	<meta name="changedby" content="alberto hernandez testa"/>
	<meta name="changed" content="2022-01-31T14:16:00"/>
	<meta name="AppVersion" content="16.0000"/>

</head>
<body lang="es-MX" link="#000080" vlink="#800000" dir="ltr"><p style="line-height: 108%; margin-bottom: 0.11in">
Solución al proyecto Multi-carrier Shipping Labels API</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Plataformas</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Para la
realización de este proyecto se utilizaron las siguientes
plataformas:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Linux Ubuntu -
sistema operativo</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Ruby 3.0.1</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Rails  6.1.4.4</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Github -
repositorio de código en línea</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Bootstrap -
estilos css</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Postman - para
probar las apis</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Idioma</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se utilizó el
idioma inglés para la parte del código (nombre de clases, nombre de
acciones, procedimientos, commits de github, etc.) por su facilidad
de uso y costumbre personal, y por la ventaja de que al trabajar con
equipos internacionales es un idioma neutral.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se utilizó el
español para las páginas de usuario final y la documentación</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Gems</p>
<p style="line-height: 108%; margin-bottom: 0.11in">rspec-rails -
para pruebas unitarias y de request</p>
<p style="line-height: 108%; margin-bottom: 0.11in">shoulda-matchers
- para pruebas unitarias de entidades y relaciones</p>
<p style="line-height: 108%; margin-bottom: 0.11in">rest-client -
cliente rest de la API del carrier, que envía los datos de los
shippings para obtener las urls de las etiquetas, id del response,
tracking number y shipment id</p>
<p style="line-height: 108%; margin-bottom: 0.11in">down - descarga
los pdfs de las etiquetas en base a los urls que envía el API del
carrier</p>
<p style="line-height: 108%; margin-bottom: 0.11in">rubyzip - para
crear archivos zips de las etiquetas en pdf</p>
<p style="line-height: 108%; margin-bottom: 0.11in">byebug - para
depuración del código</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Public folder</p>
<p style="line-height: 108%; margin-bottom: 0.11in">carpetas: 
</p>
<p style="line-height: 108%; margin-bottom: 0.11in">/public/pdfs
(guarda los archivos pdfs de las etiquetas por id solicitud-id de
shipping</p>
<p style="line-height: 108%; margin-bottom: 0.11in">/public/zips
(guarda los archivos zip de las etiquetas de cada solicitud por id de
solicitud)</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">DB seeds</p>
<p style="line-height: 108%; margin-bottom: 0.11in">se borran todas
las bases de datos y se genera el carrier: fake_carrier</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">models
migration</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">rails
g model Carrier name:string endpoint:string token:string</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">rails
g model Solicitude fecha:date status:string tracking_number:string</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">rails
g model Shipping carrier:belongs_to solicitude:belongs_to
name_from:string street_from:string city_from:string
province_from:string postal_code_from:string countr_code_from:string
name_to:string street_to:string city_to:string province_to:string
postal_code_to:string countr_code_to:string length:integer
width:integer height:integer dimensions_unit:string weight:integer
weight_unit:string status:string shipment_id:string label_url:string
id_response:string tracking_number:string</span></p>
<p lang="en-US" style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">models</span></p>
<p lang="en-US" style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">class
Carrier    </span>
</p>
<p style="line-height: 108%; margin-bottom: 0.11in">    <span lang="en-US">has_many
:shippings</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">class
Solicitude </span>
</p>
<p style="line-height: 108%; margin-bottom: 0.11in">    <span lang="en-US">has_many
:shippings</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="en-US">class
Shipping</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in">    <span lang="en-US">belongs_to
:solicitude</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in">    <span lang="en-US">belongs_to
:carrier</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in">.gitignore</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Servicio interno</p>
<p style="line-height: 108%; margin-bottom: 0.11in">modulo:
Carrierservice</p>
<p style="line-height: 108%; margin-bottom: 0.11in">clase:
SendSolicitude</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Hace la petición
al carrier con la colección de Shippings</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Librería interna</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se configuró en
:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">config/
application.rb:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">para indicar
dónde estarán los módulos que usará el sistema.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">	<span lang="en-US">config.autoload_paths
+= %W(#{config.root}/lib)</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in">Modulo
Interfaceable - este módulo es usado por los Jobs como soporte para
realizar las siguientes funciones:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">getResponse :
formatea y envía los shippings al carrier y graba el status de cada
shipping.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">downloadPdf :
descarga el archivo pdf de cada shipping</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Flujo de la
Solicitud</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Al recibir la
solicitud en nuestra API del cliente REST pasa al status: ‘pending’</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Al grabarse la
solicitud pasa al estatus: ‘processing’</p>
<p style="line-height: 108%; margin-bottom: 0.11in">se ejecutan 3
jobs:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">SolicitudeJob (al
momento de grabarse la solicitud)</p>
<p style="line-height: 108%; margin-bottom: 0.11in">SolicitudeSecondTryJob
programado para ejecutarse 1 minuto después del primer Job para los
shippings que no pudieron procesarse en el primer job en virtud de no
recibir respuesta del carrier.</p>
<p style="line-height: 108%; margin-bottom: 0.11in"> 
SolicitudeThirdTryJob programado para ejecutarse 1 minuto después
del segundo Job para los shippings que no pudieron procesarse en el
2o. job en virtud de no recibir respuesta del carrier.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Al terminar los 3
jobs si faltó algún shipping de procesamiento se marca el estatus
de la solicitud como: ‘error’, ya que fue el fin de los intentos
por alcanzar el server.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">En este punto los
pdfs de las etiquetas ya están descargados en la carpeta pública
pdfs</p>
<p style="line-height: 108%; margin-bottom: 0.11in">La solicitud es
consultada en nuestra API, si la solicitud existe y no está marcada
como error, el estatus se indica cómo ‘completed’, se crea el
archivo zip  y se devuelve en la respuesta el status y la liga para
descargar el  archivo zip</p>
<p style="line-height: 108%; margin-bottom: 0.11in">	{&quot;status&quot;:&quot;completed&quot;,</p>
<p style="line-height: 108%; margin-bottom: 0.11in">&quot;url&quot;:&quot;http://localhost:3000/api/v1/download_pdf?solicitud_id=16&quot;
}</p>
<p style="line-height: 108%; margin-bottom: 0.11in">     -	Con la
liga generada en el paso anterior y si la solicitud existe, nuestra
API permite 
</p>
<p style="line-height: 108%; margin-bottom: 0.11in">descargar el
archivo zip</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">JOBS</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se utilizaron los
Active Job de Rails, en producción se recomienda usar Sidekiq como
background processing 
</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="fr-FR">TEST</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in"><span lang="fr-FR">Se
siguió un enfoque de code a little test a little</span></p>
<p style="line-height: 108%; margin-bottom: 0.11in">se crearon:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">unit test -
básicamente se hicieron test para validar la estructura de tablas,
modelos y relaciones entre los modelos</p>
<p style="line-height: 108%; margin-bottom: 0.11in">request test  -
se validaron cada una de las 3 peticiones de la app:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Solicitar la
generación de las etiquetas</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Consultar el
estado de la generación de las etiquetas</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Generación del
archivo ZIP con las etiquetas</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">PÁGINAS WEB</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Listado de las
solicitudes:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Listado de los
shippings de una solicitud:</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Listado de
Carriers</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Consulta de
Carriers</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Edición de
Carrier</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Alta</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Validaciones de
cada campo</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Observaciones
finales</p>
<p style="line-height: 108%; margin-bottom: 0.11in"><br/>
<br/>

</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Los 3 jobs
programados en intervalos de un minuto, es una estrategia que
dependerá de la calidad del servicio del carrier y dependiendo de
esto se podrá utilizar otra estrategia, se manejo con intervalos de
1 minuto por la facilidad en la depuracion del codigo y para revision
de la app.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se usó Active
Job de Rails por su facilidad de uso, este no debería usarse en
producción.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se usó un CDN
para para servir bootstrap, en producción es mejor integrar
bootstrap en la aplicación.</p>
<p style="line-height: 108%; margin-bottom: 0.11in">Se podría haber
usado Active Storage, para asociar los archivos pdfs y zips, pero 
se decidió no hacerlo, porque la app, se resolvió así y no se tuvo
complicación, por lo que ya no fue completamente necesario.</p>
</body>
</html>
