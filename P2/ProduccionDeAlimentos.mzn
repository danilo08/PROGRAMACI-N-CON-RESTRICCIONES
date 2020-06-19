%Practica comun  PRODUCCION DE ALIMENTOS  
%Daniel López Acero

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% VARIABLES Y DATOS
int:aceites;
int:vegetales;
int:noVegetales;
%TABLA DE PRECIOS
array[1..12,1..aceites]of int:tabla;
%Precio por tnelada al que se vende el producto final 150 pr ejemplo
int:Valor;
%Maximax toneladas que se pueden refinar 1 mes de Vegetal.
int:MaxV;
%Maximax toneladas que se pueden refinar 1 mes de No vegetal.
int:MaxN;
%Capacidad de almacenamiento en la fabrica para cada tipo de aceite.
int:Mcap;
%Precio por almacenar cada tipo de aceite por mes
int:CA;
%Dureza minima y maxima.
int:MinD;
int:MaxD;
array[1..aceites]of var int:durezas;
%Minimo beneficio a obtener
int:MinB;
%Nos permite saver como se encontraba el almacen al principio de año.
array[1..aceites]of int:almacenInicial;
%El almacen al principio del año tien que quedar igual que al finalizar
array[1..12,1..aceites]of var 0..Mcap:miAlmacen;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%SOLUCION: La dividimos en 3 partes:
%Nos dice cuanto comprar de cada aceita cada mes
array[1..12, 1..aceites]of var 0..Mcap: compras;
%Que cantidades de cada aceite REFINAR cada mes.
array[1..12,1..aceites]of var 0..1000:refinado;
%Dinero
array[1..12]of var int:dinero;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Constraint asserts:

%                    FUNCIONES:
%Pienso que este problema esta muy enfocado ha facilitarse por el uso de funciones, aunque al final solo he utilizado funciones para facilitar el calculo del dinero
%Funciones auxiliares para calcular el dinero
function var int:DineroGastado(var int:mes)= (sum(j in 1..aceites) ((miAlmacen[mes,j]*CA) + (compras[mes,j]*tabla[mes,j]) ));
function var int:DineroGanado(var int:mes)=(sum(j in 1..aceites) (refinado[mes,j]*Valor) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  CONSTRAINTS:

%La cantidad final en miAlmacen debe ser igual a la inicial:
constraint(forall(i in 1..aceites) (almacenInicial[i]=miAlmacen[12,i]));
%Para el mes inicial
constraint forall(j in 1..aceites) (miAlmacen[1,j]=almacenInicial[j]+compras[1,j]-refinado[1,j]);
%Mi almacen es igual a mi almacen del mes anterior mas las compras menos lo refinado:
constraint forall(i in 2..12) ( forall(j in 1..aceites) (miAlmacen[i,j]=miAlmacen[i-1,j]+compras[i,j]-refinado[i,j]));


%Cada mes podemos refinar MAXv Maxnv como maximo:
constraint forall(i in 1..12) ( sum(j in 1..vegetales) (refinado[i,j])=MaxV);

constraint forall(i in 1..12) ( sum(j in vegetales+1..aceites) (refinado[i,j])=MaxN);



%No se puede refinar mas de lo almacenado:
constraint forall(i in 1..12) ( forall(j in 1..aceites) (refinado[i,j]<= miAlmacen[i,j]));
%no se puede refinar negativamente:
constraint forall(i in 1..12) (forall(j in 1..aceites) (refinado[i,j]>=0));
%no se puede comprar negativamente:
constraint forall(i in 1..12) (forall(j in 1..aceites) (compras[i,j]>=0));
%no se puede tener negativo en mi almacen:
constraint forall(i in 1..12) (forall(j in 1..aceites) (miAlmacen[i,j]>=0));


%Constraint de refinado:
%Lo que se refina es lo que se vende en el mes
%LA media del refinado cumple                          
%la cantidad por la dureza/la cantidad por la dureza de todos
constraint forall(i in 1..12) (sum(j in 1..aceites) (refinado[i,j]*durezas[j]) / sum(x in 1..aceites)(refinado[i,x])> MinD /\ sum(j in 1..aceites) (refinado[i,j]*durezas[j]) / sum(x in 1..aceites)(refinado[i,x])< MaxD);

%Para el primer mes
constraint dinero[1] = DineroGanado(1)-DineroGastado(1);
%No dinero negativo primer mes

%El dinero de cada mes es igual a la suma del dinero del ems anterior mas lo que he ganado menos lo que me he gastado.
constraint forall(i in 2..12) ( dinero[i] = dinero[i-1] + DineroGanado(i)-DineroGastado(i));
%El beneficio final debe ser al menos MinB
constraint dinero[12]>MinB;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve satisfy;


output ["\n"];
output ["Compras\n"];
output[ if j=1 then "Mes\(i)  " else" " endif  ++ if i<10/\j=1 then " " else "" endif ++ " \(compras[i,j])  " ++ "   " ++  if j == aceites then "\n" else "" endif |i in 1..12,j in 1..aceites];

output ["\n"];
output ["Mi Almacen\n"];
output[ if j=1 then "Mes\(i)  " else" " endif  ++ if i<10/\j=1 then " " else "" endif ++ " \(miAlmacen[i,j])  " ++ "   " ++  if j == aceites then "\n" else "" endif |i in 1..12,j in 1..aceites];

output ["\n"];
output ["Refinado\n"];
output[ if j=1 then "Mes\(i)  " else" " endif  ++ if i<10/\j=1 then " " else "" endif ++ " \(refinado[i,j])  " ++ "   " ++  if j == aceites then "\n" else "" endif |i in 1..12,j in 1..aceites];

output ["\n"];
output[ if i=1 then "Mes\(i)  " else" " endif  ++ if i<10 then " " else "" endif ++ " \(dinero[i])  " ++ "   "  |i in 1..12,];




















