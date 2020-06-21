% 1	ª Practica
%Daniel López Acero
%LA FABRICA

%3 Turnos 
%Se asignan a los trabajadores alguno de los 3 turnos con la opcion de librar
%      libra, mañana, tarde, noche
enum turnos = {l,m,t,n};

%D Dias consecutivos
int: D;
%T Trabajadores totales
int: T;
%N Numero de trabajadores por turno
int: N;

%Array de dias por trabajadores:
array[1..D,1..T] of var turnos: sol;


%MaxDT Maximo numero de dias trabajandos seguidos
int: MaxDt;

%MaxDl Maximo numero de dias librando seguidos
int: MaxDl;

%MinDt Minimo numero de dias que debe trabajar un trabajador
int: MinDt;

%Incompatibles
int: NIncom;
array[1..NIncom, 1..2] of int: incompatibles;

%Supervisores
array[1..T] of var bool:supervisores;

%Constraint asserts

constraint assert(D > 0,"El numero de dias tiene que ser como minimo 1");
constraint assert(T > 0,"El numero de trabajadores tiene que ser como minimo 1");
constraint assert(N > 0,"El numero de trabajadores por turno tiene que ser al menos de 1");
%1
constraint assert(T > N*3,"El numero de trabajadores totales debe ser mayor que el numero de trabajadores por turno por el numero de turnos");
%3
constraint assert(D > MaxDt,"Los dias deben ser mas que el MaxDt");
%4
constraint assert(D > MaxDl,"Los dias deber ser mas que MaxDl");
%7
%constraint assert(sum(i in 1..T) (bool2int(supervisores[i]))>=3,"");He querido indicar que la suma de los trabajadores que son supervisores debe ser mayor o igual a 3
%ya que si no hubiese 3 no se podria dar la condicion de 1 supervisor por turno, lo he añadido como constraint normal pero comentado ya que no se si esta bien.


%CONSTRASINTS


%1. Cada turno tiene N trabajadores y 2. Un trabajador solo puede estar en un turno cada día
constraint forall(i in 1..D) (sum (j in 1..T) (bool2int( sol[i,j]=m)) = N);
constraint forall(i in 1..D) (sum (j in 1..T) (bool2int( sol[i,j]=t)) = N);
constraint forall(i in 1..D) (sum (j in 1..T) (bool2int( sol[i,j]=n)) = N);


%2. Un trabajador solo puede estar en un turno cada día(No necesario)


%3. Dado un número MaxDT, garantizar que nadie trabaja MaxDT días consecutivos.
% Para un trabajador j queremos comprobar que desde i Dias hasta maxDt consecutivos sean disntitos de librar y todo eso sea meno o igual al Maximo numero de dias trabajando seguidos                                              
constraint forall(j in 1..T) (forall(i in 1..D) (sum(x in i..(i+MaxDt) where x<=D) (bool2int(sol[x,j] = m) + bool2int(sol[x,j] = n) + bool2int(sol[x,j] = t )) <= MaxDt));


%4. Daado un número MaxDL, garantizar que nadie tiene MaxDL días libres consecutivos.
%Como el anterior
constraint forall(j in 1..T) (forall(i in 1..D) (sum(x in i..(i+MaxDl) where x<=D) (bool2int(sol[x,j] = l)) <= MaxDl));


%5. Dado un número MinDT, garantizar que todos trabajan como mínimo MinDT en los D días.
%Por cada 1 de los trabajadores comprobamos que la suama de todos sus dias trabajados  es mayor o igual al Minimo de dias obligados a trabajar
constraint forall(j in 1..T) (sum(i in 1..D) (bool2int(sol[i,j] = m) + bool2int(sol[i,j] = n) + bool2int(sol[i,j] = t )) >=MinDt);


%6. Un trabajador no puede hacer el último turno de un día y el primero del día siguiente.
%Recorremos todos los dias menos el ultimo y  establecemos que si un trabajador ha trabajado por la noche indicamos que al dia siguiente no trabajara por la noche (!=n)Tambien hubiese servido
constraint forall(i in 1..D-1,j in 1..T) (sol[i,j]=n ->(sol[i+1,j]=t \/ sol[i+1,j]=n \/ sol[i+1,j]=l));
                                         %if.... %then                                               %endif

%7. Dada una serie de parejas de trabajadores incompatibles, dos trabajadores incompatibles no pueden estar en el mismo turno.
%Recorremos todos los incompatibles  y en cada dia comprobamos si los dos incompatibles no libran entocnes establecemos que deben tener distinto turno
constraint forall(i in 1..NIncom) (forall(j in 1..D) (sol[j,incompatibles[i,1]]!=l /\ sol[j,incompatibles[i,2]]!=l -> sol[j,incompatibles[i,1]]!=sol[j,incompatibles[i,2]] ));
                                                      %if.... (si pasa esto)                                    %then(entonce..)                                             %endif

%8. Dados cuáles de los trabajadores son “supervisores”, garantizar que en cada turno hay un supervisor.
%Recorremos los dias y por cada turno establecemos que solo debe haber 1 supervisor                        
constraint forall(i in 1..D) (forall(x in 2..4) (sum(j in 1..T )(bool2int(supervisores[j] /\ sol[i,j]=turnos[x]))=1));
%constraint (sum(i in 1..T) (bool2int(supervisores[i]))>=3);


solve satisfy;



output[  if j==1 then "SUPVS:" else "" endif   ++ "S\(j)(\(supervisores[j]))" ++"     "|j in 1..T];


output ["\n"];


output[ "Dia: \(i)  "   ++ " \(sol[i,j])  " ++ "   " ++ if i<10 then " " else "" endif ++ if j == T then "\n" else "" endif |i in 1..D,j in 1..T];














