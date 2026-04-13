% --- CONFIGURATION & STATE ---
:- dynamic at/2.
:- dynamic has/1.
:- dynamic hp/1.
:- dynamic monster_hp/2.
:- dynamic alive/1.

% --- THE WORLD DATA (MAP) ---
% connected(From, Direction, To, Description)
path(entrance, north, hallway, 'a long, dimly lit stone corridor').
path(hallway, south, entrance, 'the heavy iron doors of the dungeon').
path(hallway, east, armory, 'a room filled with rusted racks and dust').
path(hallway, west, forge, 'the Ancient Forge. The air is thick with soot and the smell of cold iron.').
path(forge, east, hallway, 'the hallway corridor.').
path(armory, west, hallway, 'the main corridor again').
path(hallway, north, throne_room, 'a massive hall with a cracked obsidian throne').
path(throne_room, south, hallway, 'the exit back to the corridor').

% --- INITIALIZATION ---
init :-
    % Reset all data
    retractall(at(_, _)), retractall(has(_)), retractall(hp(_)),
    retractall(monster_hp(_, _)), retractall(alive(_)),
    
    % Set starting state
    assertz(at(player, entrance)),
    assertz(at(iron_key, armory)),
    assertz(at(healing_potion, hallway)),
    assertz(at(skeleton, hallway)),
    assertz(at(sword, forge)),
    assertz(at(boss_dragon, throne_room)),
    assertz(hp(15)),
    assertz(monster_hp(skeleton, 5)),
    assertz(monster_hp(boss_dragon, 30)),
    assertz(alive(skeleton)),
    assertz(alive(boss_dragon)),
    
    % Display the "Welcome Screen"
    writeln('-------------------------------------------'),
    writeln('       WELCOME TO THE DRAGON SLAYER      '),
    writeln('-------------------------------------------'),
    writeln('  CONTROLS:'),
    writeln('    w. - Move North      q. - Inventory/Status'),
    writeln('    s. - Move South      f. - Grab/Get Item'),
    writeln('    a. - Move West       e. - Fight/Attack'),
    writeln('    d. - Move East       r. - Heal (Use Potion)'),
    writeln('    z. - Look Around     init. - Reset Game'),
    writeln('    x. - End Game        halt. - To Close'),
    writeln('-------------------------------------------'),
    look.

% --- CORE MECHANICS: MOVEMENT ---
move(Dir) :-
    at(player, Current),
    path(Current, Dir, Next, Desc),
    !,
    check_lock(Next),
    retract(at(player, Current)),
    assertz(at(player, Next)),
    format('You move to the ~w.~n', [Next]),
    format('It is ~w~n', [Desc]),
    look, !.

move(_) :- 
    writeln('You cannot go that way or a door is locked!').

% THE IRON KEY LOGIC
% This "gate" stops you from entering the throne_room without the key.
check_lock(throne_room) :- 
    has(iron_key), 
    writeln('You turn the Iron Key in the lock... The heavy doors creak open!'), !.
check_lock(throne_room) :- 
    writeln('The Throne Room door is locked! You need the Iron Key from the Armory.'), 
    !,fail.
check_lock(_). % All other rooms are unlocked.

% --- CORE MECHANICS: INTERACTION ---
look :-
    at(player, Loc),
    findall(I, (at(I, Loc), I \= player, I \= skeleton, I \= boss_dragon), Items),
    (Items == [] -> writeln('The floor is empty.'); format('Items here: ~w~n', [Items])),
    (at(M, Loc), alive(M) -> format('DANGER: A ~w is standing here!~n', [M]) ; true).

take(Item) :- 
    (Item == player ; alive(Item)), 
    writeln('You cannot pick that up!'), !.

take(Item) :-
    at(Item, _), % Ensure the item actually exists somewhere
    retract(at(Item, _)),
    assertz(has(Item)),
    format('You have added the ~w to your inventory.~n', [Item]), !.

take(_) :- 
    writeln('There is nothing like that here.').

% --- USE ITEM LOGIC ---
use(healing_potion) :-
    has(healing_potion),
    hp(CurrentHP),
    NewHP is CurrentHP + 10,
    retract(hp(CurrentHP)),
    assertz(hp(NewHP)),
    retract(has(healing_potion)),
    format('You drink the potion. Your HP is now ~w.~n', [NewHP]), !.

use(healing_potion) :-
    \+ has(healing_potion),
    writeln('You don\'t have a healing potion!').

% --- COMBAT SYSTEM ---
attack :-
    at(player, Loc), at(M, Loc), alive(M),
    monster_hp(M, MHP),
    
    % Logic: If you have the sword, deal 5-9 damage. Otherwise, deal 1-2.
    (has(sword) -> random(5, 10, Damage) ; random(1, 3, Damage)),
    
    NewMHP is MHP - Damage,
    retract(monster_hp(M, MHP)), assertz(monster_hp(M, NewMHP)),
    
    (has(sword) -> 
        format('You slash the ~w with your Sword for ~w damage!~n', [M, Damage]) ; 
        format('You punch the ~w for a weak ~w damage!~n', [M, Damage])),
        
    (NewMHP =< 0 -> win_battle(M) ; monster_hits_back), !.
attack :- writeln('There is nothing here to fight!').

win_battle(M) :-
    retract(alive(M)),
    format('The ~w collapses! You have won the battle!~n', [M]),
    (M == boss_dragon -> writeln('YOU FOUND THE TREASURE! YOU WIN THE GAME!'),writeln('The treasure is yours. Type "x." to finish your quest.') ; true).

monster_hits_back :-
    hp(P), random(1, 4, D), NewP is P - D,
    retract(hp(P)), assertz(hp(NewP)),
    format('The monster hits you back for ~w damage!~n', [D]),
    (NewP =< 0 -> (writeln('You have died. Game Over.'), halt) ; true).

% If the dragon is not alive, the player wins and the game exits.
finish :- 
    \+ alive(boss_dragon), % '\+' is the Prolog symbol for 'NOT'
    writeln('***********************************************'),
    writeln('   CONGRATULATIONS! YOU HAVE SAVED THE REALM   '),
    writeln('      The dragon is dead. Your quest ends.     '),
    writeln('***********************************************'),
    writeln('*******Type "halt." to CLOSE the GAME**********').

% If the player tries to 'finish' while the dragon is still alive
finish :- 
    alive(boss_dragon),
    writeln('The dragon still breathes! You cannot leave yet.'),
    !.

% --- WASD Navigation ---
w :- move(north).
s :- move(south).
a :- move(west).
d :- move(east).

% --- Common Gaming Shortcuts ---
q :- status.             % 'q' for Inventory/Status
r :- use(healing_potion). % 'r' for Heal
e :- attack.             % 'e' for Fight/Attack
z :- look.               % 'z' for Look around
x :- finish.		% 'x' for End Game

%--- The "Grab" Logic ---
f :- 
    at(player, Loc),
    at(Target, Loc),
    Target \= player,
    % CRITICAL: Check that the target is NOT a monster
    \+ alive(Target), 
    take(Target), 
    !.

f :- 
    at(player, Loc),
    at(Target, Loc),
    alive(Target),
    writeln('You cannot pick up a living creature! Fight it first.'), !.

f :- 
    writeln('There is nothing here to grab.').

% --- UTILITIES ---
status :-
    hp(CurrentHP),
    findall(I, has(I), Inv),
    format('HP: ~w | Inventory: ~w~n', [CurrentHP, Inv]).

help :-
    writeln('move(north/south/east/west).'),
    writeln('take(item_name).'),
    writeln('attack.'),
    writeln('status.').