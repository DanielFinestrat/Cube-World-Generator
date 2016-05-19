-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- INICIALIZACION ///////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
delete objects
free objects
try(destroyDialog generador) catch()

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- VARIABLES  /////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

-- GENERALES
tipoMundo = 1 -- Densidad de 1 a 3: Luna(1), Marte(2) y Jupiter(3).

tamX = 50
tamY = 50
tamMaxZ = 25

sueloarray = #(#()) -- Array de bloques donde debe ir el suelo
segundosueloarray = #(#()) -- Array de bloques donde debe ir el suelo
piedrasarray = #(#()) -- Array con la posicion de las piedras piedrasarray[1][1] = posX, piedrasarray[1][2] = posY (Deberia estar todo a un radio de 3 a 5 de las piedras)

numRocas = 7

numMontañas = 10
tmñBaseMontañas = 20
alturaMontañas = 20

-- VARIABLES DE CONSTRUCCIONES
mayaCantidad = 3
mayaEscalones = 100
mayaTmñBase = 10
mayaAltura = 10

egipciaCantidad = 3
egipciaTmñBase = 10
egipciaAltura = 10

tailandesaCantidad = 3
tailandesaEscalones = 100
tailandesaTmñBase = 10
tailandesaAltura = 10

puenteCantidad = 5
puenteLongitud = 3
puenteAncho = 1
arcosPuente = 2

ruinaCantidad = 5
tmñBaseRuinas = 5

-- VARIABLES DE VEGETACION
numBosques = 3 --Número de bosques, cada uno con la misma densidad.
densidad = 2 -- Densidad de 1 a 4, poca a extrema.

-- TEXTURAS
texturaSueloRuta = sysInfo.currentdir + "\\Texturas\luna.jpg"
texturaLunaRuta = sysInfo.currentdir + "\\Texturas\luna.jpg"
texturaMarteRuta = sysInfo.currentdir + "\\Texturas\marte.jpg"
texturaJupiterRuta = sysInfo.currentdir + "\\Texturas\jupiter.jpg"
texturaRoca = sysInfo.currentdir + "\\Texturas\\roca.jpg"

-- MATERIALES
matSuelo = StandardMaterial()
bitmapSuelo = bitmaptexture filename: texturaSueloRuta
matSuelo.diffusemap = bitmapSuelo
matSuelo.showInViewport = on
	
matRoca = StandardMaterial()
bitmapRoca = bitmaptexture filename: texturaRoca
matRoca.diffusemap = bitmapRoca
matRoca.showInViewport = on

-- SKYBOXES
skyRuta = sysInfo.currentdir + "\\Skybox\luna.jpg"
skyLunaRuta = sysInfo.currentdir + "\\Skybox\luna.jpg"
skyMarteRuta = sysInfo.currentdir + "\\Skybox\marte.jpg"
skyJupiterRuta = sysInfo.currentdir + "\\Skybox\jupiter.jpg"
bitmapSky = bitmaptexture filename: skyRuta
environmentMap = bitmapSky
useEnvironmentMap  = true
bitmapSky.coordinates.mapping= 3

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- FUNCIONES /////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --

fn round_to val n = (
	local mult = 10.0 ^ n
	(floor ((val * mult) + 0.5)) / mult
)

fn cambiarTexturaSuelo tipoMundo = (
	if tipoMundo == 1 then texturaSueloRuta = texturaLunaRuta
	else if tipoMundo == 2 then texturaSueloRuta = texturaMarteRuta
	else if tipoMundo == 3 then texturaSueloRuta = texturaJupiterRuta
	bitmapSuelo=bitmaptexture filename: texturaSueloRuta
	matSuelo.diffusemap = bitmapSuelo
)

fn cambiarSkyboxes tipoMundo = (
	if tipoMundo == 1 then skyRuta = skyLunaRuta
	else if tipoMundo == 2 then skyRuta = skyMarteRuta
	else if tipoMundo == 3 then skyRuta = skyJupiterRuta
	bitmapSky = bitmaptexture filename: skyRuta
	environmentMap = bitmapSky
	bitmapSky.coordinates.mapping= 3
)

fn crearSuelo tamX tamY = (

	for i = 1 to tamX-1  do(
		append sueloarray #(#())
		append segundosueloarray #(#())
		for j = 1 to tamY-1 do(
			
			/*Creación, X e Y*/
			
			if(i == 1 and j == 1) then (
				sueloarray[i][j] = Box lengthsegs:1 widthsegs:1 heightsegs:1 length: 1 width:1 height:1 mapcoords:on pos:[i-1, j-1, 0]
				sueloarray[i][j].material = matSuelo
			)
			else if (j == 1) then( /*Si es principio de fila, hacer...*/
				sueloarray[i][j] = instance sueloarray[i-1][j]
				sueloarray[i][j].pos.x = i-1
				sueloarray[i][j].pos.y = j-1
			)
			else( /*Si no es principio de fila, hacer...*/
				sueloarray[i][j] = instance sueloarray[i][j-1]
				sueloarray[i][j].pos.x=i-1
				sueloarray[i][j].pos.y=j-1
			)
			
			
			/* Z */
			
			/*Calculo la desviacion*/
			desviZ = random 0 100
			if desviZ > 97 then (desviZ = 1)
			else if desviZ < 3 then (desviZ =-1)
			else desviZ = 0
			
			if(i == 1 or j == 1) then (sueloarray[i][j].pos.z = sueloarray[i][j].pos.z + desviZ)
			else(
				sueloarray[i][j].pos.z = (round_to (((sueloarray[i-1][j].pos.z+sueloarray[i][j-1].pos.z+sueloarray[i-1][j-1].pos.z)/3)) 0) + desviZ
			)
			
			/*Correcion 1 Z(Que no se salgan)*/
			if sueloarray[i][j].pos.z > 1 then sueloarray[i][j].pos.z = 1
			if sueloarray[i][j].pos.z < -1 then sueloarray[i][j].pos.z = -1
				
			segundosueloarray[i][j] = sueloarray[i][j] -- Me guardo el terreno final (o el superior/inferior, ver abajo) en el segundosueloarray
				
			/*Correcion 2 Z(Que no hayan agujeros por abajo)*/
			if(i == 1 or j == 1) then()
			else if(sueloarray[i][j].pos.z - sueloarray[i-1][j].pos.z > 1) then (
				relleno = instance sueloarray[i][j]
				relleno.pos.z = sueloarray[i][j].pos.z-1
				segundosueloarray[i][j] = relleno -- ME GUARDO EL INFERIOR
			)
			else if(sueloarray[i][j].pos.z - sueloarray[i][j-1].pos.z > 1) then (
				relleno = instance sueloarray[i][j]
				relleno.pos.z = sueloarray[i][j].pos.z-1
				segundosueloarray[i][j] = relleno -- ME GUARDO EL INFERIOR
			)
			else if(sueloarray[i][j].pos.z - sueloarray[i-1][j-1].pos.z > 1) then (
				relleno = instance sueloarray[i][j]
				relleno.pos.z = sueloarray[i][j].pos.z-1
				segundosueloarray[i][j] = relleno -- ME GUARDO EL INFERIOR
			)
			
			/*Correcion 3 Z(Que no hayan agujeros por arriba)*/
			if(i == 1 or j == 1) then()
			else if(sueloarray[i][j].pos.z - sueloarray[i-1][j].pos.z < 0) then (
				relleno = instance sueloarray[i][j]
				relleno.pos.z = sueloarray[i][j].pos.z+1
				segundosueloarray[i][j] = relleno -- ME GUARDO EL SUPERIOR
			)
			else if(sueloarray[i][j].pos.z - sueloarray[i][j-1].pos.z < 0) then (
				relleno = instance sueloarray[i][j]
				relleno.pos.z = sueloarray[i][j].pos.z+1
				segundosueloarray[i][j] = relleno -- ME GUARDO EL SUPERIOR
			)
			else if(sueloarray[i][j].pos.z - sueloarray[i-1][j-1].pos.z < 0) then (
				relleno = instance sueloarray[i][j]
				relleno.pos.z = sueloarray[i][j].pos.z+1
				segundosueloarray[i][j] = relleno -- ME GUARDO EL SUPERIOR
			)
		)
	)
)

fn crearSol = (
	sol = Omnilight multiplier:2 shadowMultiplier:30 pos:[tamX, tamY, tamMaxZ*5]
	sol.baseObject.castShadows=true
	if tipoMundo == 1 then sol.rgb = color 255 255 255
	else if tipoMundo == 2 then sol.rgb = color 255 0 0
	else if tipoMundo == 3 then  sol.rgb = color 255 255 255
)

fn crearPiramideEgipcia egipciaCantidad egipciaTmñBase egipciaAltura = (
	
	egipciaAltura += egipciaAltura
	for altura = 1 to (egipciaAltura) do (
		
		crearNivelPiramideEgipcia egipciaTmñBase egipciaTmñBase altura
		egipciaTmñBase -= 1
	)
	
	
)

fn crearNivelPiramideEgipcia tamX tamY z = (
	empezarX = - (tamX/2)
	empezarY = - (tamY/2)
	acabarX = (tamX/2) 
	acabarY = (tamY/2)
	for contX = empezarX to (acabarX)  do(
		for contY = empezarY to (acabarY) do(
			myBox = Box lengthsegs:1 widthsegs:1 heightsegs:1 length: 1 width:1 height:1 mapcoords:on pos:[contX, contY, z]
			myBox.material = matSuelo
		)
	)
)

-- Para aplanar pasar la X donde empezar, la Y donde empezar, la Z a donde quieres aplanar (Uno menos de donde vayas a colocarlo) y las dimensiones x(I) e y(J) de tu edificacion
fn aplanar x y z i j = (
	for cont1 = x - i to x + i do(
		for cont2 = y - j to y + j do(
			sueloArray[cont1][cont2].pos.z = z
			segundosueloarray[cont1][cont2].pos.z = z
		)
	)
)

fn crearCapasRoca x y z i j = (
	for cont1 = x - i to x do(
		for cont2 = y - j to y do(
			fragRoca = Box lengthsegs:1 widthsegs:1 heightsegs:1 length: 1 width:1 height:1 mapcoords:on pos:[cont1, cont2, z]
			fragRoca.material = matRoca
		)
	)
	z = z +1
	i = i - 1
	j = j - 1
	if(i > 0 and j > 0) then ( crearCapasRoca x y z i j )
)

fn crearRoca = (
	append piedrasarray #(#())
	posX = random 5 (tamX - 5)
	posY = random 5 (tamY - 5)
	
	i = 1
	while piedrasarray[i][1] == undefined do( i = i + 1 )
	piedrasarray[i][1] = posX
	piedrasarray[i][2] = posX
		
	posZ = 1
	tamRocaX = random 1 3
	tamRocaY = random 1 2
	aplanar posX posY (posZ-1) tamRocaX tamRocaY
	crearCapasRoca posX posY posZ tamRocaX tamRocaY
)

fn crearRocas numRocas = (
	for i = 0 to numRocas  do( crearRoca() )
)

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- ROLLOUTS //////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
rollout generador "Generador de Mundos Minecraft" width:410 height:710(
	subRollout rollDentro "Dentro" pos:[5,10] width:400 height:700
)

rollout seleccionarMundo "Tipo de Mundo a Generar" width:296 height:104(
	radiobuttons radTipoDeMundo labels:#("Luna", "Marte", "Júpiter")
	on radTipoDeMundo changed param do(
		tipoMundo = radTipoDeMundo.state
		cambiarTexturaSuelo tipoMundo
		cambiarSkyboxes tipoMundo
	)
)

rollout tamañoMundo "Tamaño del Mundo" width:296 height:104(
	spinner spinTamX "Tamaño X" range:[25,200,50] type:#integer
	spinner spinTamY "Tamaño Y" range:[25,200,50] type:#integer
	spinner spinTamMaxZ "Tamaño Maximo Z" range:[25,200,25] type:#integer
	on spinTamX changed param do tamX = spinTamX.value
	on spinTamY changed param do tamY = spinTamY.value
	on spinTamMaxZ changed param do tamMaxZ = spinTamMaxZ.value
)

rollout piedras "Parametros sobre Rocas" width:296 height:104(
	spinner spinNumRocas "Número de Rocas" range:[0, 300, 7] type:#integer
	on spinNumRocas changed param do numRocas = spinNumRocas.value
)

rollout montañas "Parametros sobre Montañas" width:296 height:104(
	spinner spinNumMontañas "Número de Montañas" range:[0, 200, 10] type:#integer
	spinner spinTamBaseMont "Tamaño de la Base" range:[10, 100, 20] type:#integer
	spinner spinTamAlturaMont  "Altura de las Montañas" range:[10, 100, 20] type:#integer
	on spinNumMontañas changed param do numMontañas = spinNumMontañas.value
	on spinTamBaseMont changed param do tmñBaseMontañas = spinTamBaseMont.value
	on spinTamAlturaMont changed param do alturaMontañas = spinTamAlturaMont.value
)

rollout maya "Parametros sobre Piramides Maya" width:296 height:104(
	spinner spinCantidadMaya "Número de Piramides Maya" range:[0, 300, 3] type:#integer
	spinner spinEscalonesMaya "Número de Escalones" range:[100, 1000, 100] type:#integer
	spinner spinTamBaseMaya "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaMaya  "Altura de las piramides" range:[10, 100, 10] type:#integer
	on spinCantidadMaya changed param do mayaCantidad = spinCantidadMaya.value
	on spinEscalonesMaya changed param do mayaEscalones = spinEscalonesMaya.value
	on spinTamBaseMaya changed param do mayaTmñBase = spinTamBaseMaya.value
	on spinTamAlturaMaya changed param do mayaAltura = spinTamAlturaMaya.value
)

rollout egipcia "Parametros sobre Piramides Egipcias" width:296 height:104(
	spinner spinCantidadEgipcia "Número de Piramides Egipcias" range:[0, 300, 3] type:#integer
	spinner spinTamBaseEgipcia "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaEgipcia  "Altura de las piramides" range:[10, 100, 10] type:#integer
	on spinCantidadEgipcia changed param do egipciaCantidad = spinCantidadEgipcia.value
	on spinTamBaseEgipcia changed param do egipciaTmñBase = spinTamBaseEgipcia.value
	on spinTamAlturaEgipcia changed param do egipciaAltura = spinTamAlturaEgipcia.value
)

rollout tailandesa "Parametros sobre Piramides Tailandesas" width:296 height:104(
	spinner spinCantidadTailandesa "Número de Piramides Tailandesas" range:[0, 300, 3] type:#integer
	spinner spinEscalonesTailandesa "Número de Escalones" range:[10, 1000, 100] type:#integer
	spinner spinTamBaseTailandesa "Tamaño de la Base" range:[10, 100, 10] type:#integer
	spinner spinTamAlturaTailandesa  "Altura de las piramides" range:[10, 100, 10] type:#integer
	on spinCantidadTailandesa changed param do tailandesaCantidad = spinCantidadTailandesa.value
	on spinEscalonesTailandesa changed param do tailandesaEscalones = spinEscalonesTailandesa.value
	on spinTamBaseTailandesa changed param do tailandesaTmñBase = spinTamBaseTailandesa.value
	on spinTamAlturaTailandesa changed param do tailandesaAltura = spinTamAlturaTailandesa.value
)

rollout puentes "Parametros sobre Puentes" width:296 height:104(
	spinner spinCantidadPuentes "Número de Puentes" range:[0, 500, 5] type:#integer
	spinner spinLongPuente "Longitud del Puente" range:[5, 50, 5] type:#integer
	spinner spinAnchPuente "Ancho del Puente" range:[1, 10, 1] type:#integer
	spinner spinArcosPuente  "Arcos del Puente" range:[1, 20, 2] type:#integer
	on spinCantidadPuentes changed param do puenteCantidad = spinCantidadPuentes.value
	on spinLongPuente changed param do puenteLongitud = spinLongPuente.value
	on spinAnchPuente changed param do puenteAncho = spinAnchPuente.value
	on spinArcosPuente changed param do arcosPuente = spinArcosPuente.value
)

rollout ruinas "Parametros sobre las ruinas" width:296 height:104(
	spinner spinCantidadRuinas "Número de Ruinas" range:[0, 500, 5] type:#integer
	spinner spinTamRuinas "Tamaño de las Ruinas" range:[3, 50, 5] type:#integer
	on spinCantidadRuinas changed param do ruinaCantidad = spinCantidadRuinas.value
	on spinTamRuinas changed param do tmñBaseRuinas = spinTamRuinas.value
)

rollout vegetacion "Parametros sobre la Vegetacion" width:296 height:104(
	spinner spinNumBosques "Numero de Bosques" range:[0, 300, 3] type:#integer
	dropdownlist dropDensidad "Densidad de Bosques" items:#("Poca", "Normal", "Mucha", "Extrema") selection: 2 
	on spinNumBosques changed param do numBosques = spinNumBosques.value
	on dropDensidad selected changed do densidad = dropDensidad.selection
)

rollout generator "Generar Nuevo Mundo" width:296 height:104(
	button generar "Generar Nuevo Mundo"
	on generar pressed do (
		crearSuelo tamX tamY
		crearSol()
		crearRocas numRocas
		--crearPiramideEgipcia egipciaCantidad egipciaTmñBase egipciaAltura
		try(destroyDialog generador) catch())
)

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- GENERAR MENÚ /////////////////////////////////////////////////////////////////////////////////////////////////////// --
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// --
createdialog generador
AddSubRollout generador.rollDentro seleccionarMundo
AddSubRollout generador.rollDentro tamañoMundo
AddSubRollout generador.rollDentro piedras
AddSubRollout generador.rollDentro montañas
AddSubRollout generador.rollDentro maya
AddSubRollout generador.rollDentro egipcia
AddSubRollout generador.rollDentro tailandesa
AddSubRollout generador.rollDentro puentes
AddSubRollout generador.rollDentro ruinas
AddSubRollout generador.rollDentro vegetacion
AddSubRollout generador.rollDentro generator
