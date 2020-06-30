eclipse(arrecifes,buenosAires,horario(17,44),altura(2.5),duracion(0,40)).
eclipse(bellaVista,sanJuan,horario(17,41),altura(11.5),duracion(2,27)).
eclipse(carmenDeAreco,buenosAires,horario(17,44),altura(2.1),duracion(1,30)).
eclipse(chacabuco,buenosAires,horario(17,43),altura(2.6),duracion(2,07)).
eclipse(chepes,laRioja,horario(17,42),altura(8.9),duracion(2,03)).
eclipse(ezeiza,buenosAires,horario(17,44),altura(0.9),duracion(1,01)).
eclipse(jachal,sanJuan,horario(17,41),altura(11.1),duracion(1,39)).
eclipse(pergamino,buenosAires,horario(17,44),altura(2.9),duracion(0,56)).
eclipse(quines,sanLuis,horario(17,42),altura(7.8),duracion(2,13)).
eclipse(rodeo,sanJuan,horario(17,41),altura(11.5),duracion(2,16)).
eclipse(rioCuarto,cordoba,horario(17,42),altura(6.3),duracion(1,54)).
eclipse(venadoTuerto,santaFe,horario(17,43),altura(4.1),duracion(2,11)).
eclipse(merlo,sanLuis,horario(17,42),altura(7.1),duracion(2,19)).

servicios(telescopio,bellaVista).
servicios(telescopio,chepes).
servicios(telescopio,ezeiza).
servicios(reposerasPublicas,chacabuco).
servicios(reposerasPublicas,arrecifes).
servicios(reposerasPublicas,chepes).
servicios(reposerasPublicas,venadoTuerto).
servicios(observatorioAstronomico,quines).
servicios(lentes,quines).
servicios(lentes,rodeo).
servicios(lentes,rioCuarto).
servicios(lentes,merlo).


unBuenLugar(Lugar):-
    eclipse(Lugar,_,_,altura(Grados),_),
    Grados  >10.

unBuenLugar(Lugar):-
    eclipse(Lugar,_,horario(17,Minutos),_,_),
    Minutos > 42.

lugaresSinServicios(Lugar):-
    eclipse(Lugar,_,_,_,_),
    not(servicios(_,Lugar)).

provinciaConUnaCuidad(Provincia):-
    eclipse(Lugar,Provincia,_,_,_),
    forall(eclipseEnSegs(Lugar1,Provincia,_,_,_),Lugar == Lugar1).

eclipseEnSegs(Lugar,Provincia,Horario,Altura,DuracionFinal):-
    eclipse(Lugar,Provincia,Horario,Altura,Duracion),
    pasarASegundos(Duracion,DuracionFinal).

pasarASegundos(duracion(Min,Segs),DuracionFinal):-
    DuracionFinal is Segs + Min * 60.

lugarDondeDuraMas(Lugar):-
    eclipseEnSegs(Lugar,_,_,_,Duracion),
    forall((eclipseEnSegs(Lugar2,_,_,_,Duracion1),Lugar\=Lugar2 ),Duracion > Duracion1) . 

%% decidi hacer lo de pasar a segundos como un predicado con los demas datos, mas facil de trabajar.
promedio(Lista,Resultado):-
    sumlist(Lista, Suma),
    length(Lista, Cantidad),
    Resultado is Suma / Cantidad.
    

duracionPromedioPais(Promedio):-
    findall(Duracion, eclipseEnSegs(_,_,_,_,Duracion), Lista),
    promedio(Lista,Promedio).
    
duracionPromedioProvincia(Provincia,Promedio):-
    eclipseEnSegs(_,Provincia,_,_,_),
    findall(Duracion,eclipseEnSegs(_,Provincia,_,_,Duracion),Lista),
    promedio(Lista,Promedio).

duracionPromedioDeCuidadesConTelescopio(Servicio,Promedio):-
    servicios(Servicio,_),
    findall(Duracion,(eclipseEnSegs(Lugar,_,_,_,Duracion),servicios(Servicio,Lugar)),Lista),
    promedio(Lista,Promedio).
