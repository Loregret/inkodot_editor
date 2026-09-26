// =====================================================================
//  ESCAPE FROM BLACKMOOR
//  A single-file Ink script
//  ---------------------------------------------------------------------
//  Endless days · 3 actions per day · 3 trainable stats
//  Inventory of tools & contraband · 6 escape routes · Heat & Contacts
// =====================================================================

LIST Inv = Spoon, SharpenedSpoon, Lockpick, Shank, MetalFile, Crowbar, Rope, Map, Paper, ForgedPapers, GuardUniform, Keycard

VAR inventory = ()

VAR strength     = 0
VAR charisma     = 0
VAR intelligence = 0

VAR day     = 1
VAR actions = 3

VAR cigarettes = 0
VAR bedsheets  = 0
VAR heat       = 0
VAR contacts   = 0
VAR vell       = 0

VAR wall      = 0
VAR tunnel    = 0
VAR papers    = 0
VAR loose_bar = false
VAR searched  = 0

-> Cell


// =====================================================================
//  THE CELL — MAIN HUB
// =====================================================================

=== Cell ===
{ actions <= 0:
    -> Night
}
Day {day} — {actions} {actions == 1:action|actions} left.
Strength {strength} · Charisma {charisma} · Intelligence {intelligence} · Smokes {cigarettes} · Heat {heat}
{ LIST_COUNT(inventory) > 0:
    Carrying: {inventory}.
- else:
    Your pockets are empty.
}
{ heat >= 5: The screws have been giving you long looks lately. }
{ heat >= 8: One more wrong move and it's the hole for you. }

Blackmoor Prison. Iron cot, tin bucket, barred window, and a door that has never once been opened for you.

+ [Out to the yard] -> Yard
+ [Down to the workshop] -> Workshop
+ [Over to the cafeteria] -> Cafeteria
+ [Into the laundry] -> Laundry
+ [Up to the library] -> Library
+ [Search your own cell] -> Search_Cell
+ [Go looking for Officer Vell] -> Vell
+ [Study your escape plans] -> Plans
+ [Make your move] -> Escape_Menu


// =====================================================================
//  THE YARD
// =====================================================================

=== Yard ===
Cracked concrete, a rusted pull-up frame, razor wire stitched against a white sky.

+ [Lift the weight plates until your arms quit] -> Yard_Strength
+ [Talk to whoever will talk to you] -> Yard_Charisma
+ [Walk the fence line, counting towers] -> Yard_Scout
+ [Back to your cell] -> Cell

=== Yard_Strength ===
~ actions = actions - 1
~ strength = strength + 1
~ temp r = RANDOM(1, 3)
{ r == 1: You hang from the crossbar until your fingers stop being yours. }
{ r == 2: You load the rusted plates and press until the yard goes soft at the edges. }
{ r == 3: You run laps of the exercise cage, counting the wire. }
Strength is now {strength}.
-> End_Action

=== Yard_Charisma ===
~ actions = actions - 1
~ charisma = charisma + 1
~ contacts = contacts + 1
~ temp r = RANDOM(1, 3)
{ r == 1: You lose three hands of cards and win two friendships. }
{ r == 2: Old Marrow talks about his daughter for an hour. You listen. That's the trick. }
{ r == 3: You trade a joke with a man from C-block and remember his name. }
Charisma is now {charisma}. Contacts {contacts}.
-> End_Action

=== Yard_Scout ===
~ actions = actions - 1
~ intelligence = intelligence + 1
{ heat > 0:
    ~ heat = heat - 1
    You keep your hands in your pockets and your face bored. A trusty stops watching you.
- else:
    You memorise the tower rotations. Fourteen minutes. Always fourteen.
}
Intelligence is now {intelligence}.
-> End_Action


// =====================================================================
//  THE WORKSHOP
// =====================================================================

=== Workshop ===
Oil, hot metal, and a guard reading a paperback at the end of the bench.

+ [Work your shift] -> Workshop_Shift
+ { inventory ? Spoon } [Grind your spoon into an edge] -> Workshop_Sharpen
+ { not (inventory ? MetalFile) } [Palm a metal file off the tool rack] -> Workshop_File
+ { not (inventory ? Crowbar) } [Go for the crowbar in the maintenance locker] -> Workshop_Crowbar
+ { (inventory ? Spoon) && not (inventory ? Lockpick) } [File your spoon into a lockpick] -> Workshop_Lockpick
+ { ((inventory ? Spoon) || (inventory ? MetalFile)) && not (inventory ? Shank) } [Grind a shank out of scrap] -> Workshop_Shank
+ [Back to your cell] -> Cell

=== Workshop_Shift ===
~ actions = actions - 1
~ temp pay = RANDOM(1, 2)
~ cigarettes = cigarettes + pay
You bend sheet steel for six hours. The foreman slips you {pay} cigarettes' worth of barter and looks the other way.
-> End_Action

=== Workshop_Sharpen ===
~ actions = actions - 1
~ inventory -= Spoon
~ inventory += SharpenedSpoon
Half an hour on the whetstone and the spoon is a blade on a handle. Ugly. Effective.
-> End_Action

=== Workshop_File ===
~ actions = actions - 1
{ intelligence >= 4 || charisma >= 4:
    You wait for the guard to reach the end of a chapter, then lift the file.
    ~ inventory += MetalFile
    A metal file. Slow — but it will eat through a bar.
- else:
    You reach for the rack. The guard looks up. You take a rag instead.
    ~ heat = heat + 1
}
-> End_Action

=== Workshop_Crowbar ===
~ actions = actions - 1
{ strength >= 5:
    You wait for the shift bell and slide the crowbar down your trouser leg.
    ~ inventory += Crowbar
    ~ heat = heat + 1
- else:
    The locker is bolted and the bar is heavier than it looks. You leave it.
    ~ heat = heat + 1
}
-> End_Action

=== Workshop_Lockpick ===
~ actions = actions - 1
{ intelligence >= 5:
    ~ inventory -= Spoon
    ~ inventory += Lockpick
    Twenty minutes with the file and the spoon becomes two hooks and a tension wrench.
- else:
    You bend the spoon and swear quietly. It'll do for soup.
    ~ heat = heat + 1
}
-> End_Action

=== Workshop_Shank ===
~ actions = actions - 1
{ intelligence >= 3 || strength >= 3:
    ~ inventory += Shank
    A blade of scrap, wrapped in tape, hidden in the seam of your mattress. You hope you never need it.
- else:
    You cut your thumb open and learn nothing.
    ~ heat = heat + 1
}
-> End_Action


// =====================================================================
//  THE CAFETERIA
// =====================================================================

=== Cafeteria ===
Steam, shouting, and four hundred spoons moving at once.

+ [Eat slowly and listen] -> Cafeteria_Gossip
+ { not (inventory ? Spoon) } [Palm a spoon off the tray stack] -> Cafeteria_Spoon
+ { not (inventory ? Map) && cigarettes >= 2 } [Buy a map from Old Marrow — 2 smokes] -> Cafeteria_Map
+ [Back to your cell] -> Cell

=== Cafeteria_Gossip ===
~ actions = actions - 1
~ contacts = contacts + 1
{ charisma >= 3:
    ~ charisma = charisma + 1
    You end up at the loud table, and by the end of the meal three people owe you favours.
- else:
    You eat alone and learn that the drain in the laundry backs up on Thursdays.
}
Contacts {contacts}.
-> End_Action

=== Cafeteria_Spoon ===
~ actions = actions - 1
~ inventory += Spoon
You palm a spoon off the tray stack and it vanishes up your sleeve.
{ charisma < 3 && intelligence < 3:
    A trusty watches you a beat too long.
    ~ heat = heat + 1
}
-> End_Action

=== Cafeteria_Map ===
~ actions = actions - 1
~ cigarettes = cigarettes - 2
~ inventory += Map
Old Marrow draws the sewer lines on the back of a menu and takes your smokes without looking at you.
-> End_Action


// =====================================================================
//  THE LAUNDRY
// =====================================================================

=== Laundry ===
Steam, bleach, and rows of sheets turning through the mangle.

+ [Work the mangle and pocket what you can] -> Laundry_Sheets
+ { not (inventory ? GuardUniform) } [Go through the officers' basket] -> Laundry_Uniform
+ { bedsheets >= 2 && not (inventory ? Rope) } [Braid two sheets into a rope] -> Laundry_Rope
+ [Back to your cell] -> Cell

=== Laundry_Sheets ===
~ actions = actions - 1
~ bedsheets = bedsheets + 1
You fold sheets for an hour. One of them never makes it back to the pile.
Sheets: {bedsheets}.
-> End_Action

=== Laundry_Uniform ===
~ actions = actions - 1
{ charisma >= 4 || intelligence >= 4:
    ~ inventory += GuardUniform
    ~ heat = heat + 2
    A captain's spare uniform, still in its paper. It goes under your mattress, folded flat as a bible.
- else:
    You're still elbow-deep in the basket when a screw walks the row.
    ~ heat = heat + 2
    "Hands where I can see them."
}
-> End_Action

=== Laundry_Rope ===
~ actions = actions - 1
~ bedsheets = bedsheets - 2
~ inventory += Rope
You braid two sheets into twelve feet of rope and wear it under your shirt like a guilty conscience.
-> End_Action


// =====================================================================
//  THE LIBRARY
// =====================================================================

=== Library ===
A stained ceiling, three shelves of donated paperbacks, and a chessboard missing a queen.

+ [Read until your eyes ache] -> Library_Study
+ { not (inventory ? Paper) } [Tear a blank page out of the ledger] -> Library_Paper
+ [Watch the guards' routine from the window] -> Library_Routines
+ [Back to your cell] -> Cell

=== Library_Study ===
~ actions = actions - 1
~ intelligence = intelligence + 1
~ temp r = RANDOM(1, 3)
{ r == 1: You read a water-damaged chemistry primer three times. Some of it stays. }
{ r == 2: You play chess against yourself and lose. }
{ r == 3: You teach yourself the difference between a warder's key and a master key. }
Intelligence is now {intelligence}.
-> End_Action

=== Library_Paper ===
~ actions = actions - 1
~ inventory += Paper
You tear a blank page out of the back of the visitors' ledger and fold it into your sock.
-> End_Action

=== Library_Routines ===
~ actions = actions - 1
~ intelligence = intelligence + 1
{ heat > 0:
    ~ heat = heat - 1
    You sit very still and very bored until they stop noticing you.
- else:
    Fourteen minutes between the tower and the gate. Always fourteen.
}
Intelligence is now {intelligence}.
-> End_Action


// =====================================================================
//  SEARCH YOUR CELL
// =====================================================================

=== Search_Cell ===
Your cell. Six paces by four. You've counted.

+ [Tear up the floor tiles] -> Search_Floor
+ [Work the window bars] -> Search_Bars
+ [Stop searching] -> Cell

=== Search_Floor ===
~ actions = actions - 1
~ searched = searched + 1
{ searched == 1:
    Under the third tile: a hollow. Inside, a dead man's kit — a folded map and four cigarettes.
    ~ inventory += Map
    ~ cigarettes = cigarettes + 4
}
{ searched == 2:
    You find a loose nail and a great deal of damp. You keep the nail.
}
{ searched >= 3:
    Dust, damp, and the smell of the drain. Nothing else.
}
-> End_Action

=== Search_Bars ===
~ actions = actions - 1
{ loose_bar:
    You work soap into the crack so the dust doesn't show.
- else:
    ~ loose_bar = true
    The fourth bar in the window rocks in its socket. Mortar sifts onto the sill. You pack it back with soap and say nothing.
}
-> End_Action


// =====================================================================
//  OFFICER VELL
// =====================================================================

=== Vell ===
Officer Vell smokes alone by the gate hut, watching nothing in particular.

+ [Chat her up] -> Vell_Talk
+ { vell >= 3 && not (inventory ? Keycard) } [Lift her keycard while she's laughing] -> Vell_Keycard
+ { contacts >= 4 && cigarettes >= 8 && not (inventory ? Keycard) } [Buy a keycard through contacts — 8 smokes] -> Vell_Buy
+ [Back to your cell] -> Cell

=== Vell_Talk ===
~ actions = actions - 1
{ charisma >= vell + 2:
    ~ vell = vell + 1
    ~ charisma = charisma + 1
    She laughs at something you said. Then she looks annoyed at herself for laughing.
    Rapport with Vell: {vell}.
- else:
    She looks at you the way she looks at the wall.
    Rapport with Vell: {vell}.
}
-> End_Action

=== Vell_Keycard ===
~ actions = actions - 1
{ charisma >= 6:
    ~ inventory += Keycard
    ~ heat = heat + 2
    Two fingers, one pocket, and her card is in your waistband. She never stops talking about her sister.
- else:
    Your hand is halfway there when she catches your wrist.
    ~ heat = heat + 3
    "Try that again and I'll break it."
}
-> End_Action

=== Vell_Buy ===
~ actions = actions - 1
~ cigarettes = cigarettes - 8
~ inventory += Keycard
A trusty takes your smokes and, two days later, a master keycard appears in your laundry bundle.
-> End_Action


// =====================================================================
//  ESCAPE PLANS (free to read)
// =====================================================================

=== Plans ===
You lie on your cot and run the numbers one more time.

STR {strength} · CHA {charisma} · INT {intelligence}
Heat {heat} · Contacts {contacts} · Smokes {cigarettes} · Sheets {bedsheets}

• The east wall — needs Strength 8+ and a Sharpened Spoon or Crowbar. Progress {wall}/4.
• The tunnel — needs Strength 4+ and any digging tool. Progress {tunnel}/6.
• The rooftop — needs Rope and Strength 6+. One attempt, no second chances.
• The bribe — needs Vell rapport 4+ and 8 cigarettes.
• The uniform — needs a Guard Uniform and a Keycard.
• The forged order — needs Paper, Intelligence 7+, three nights of work, then nerve at the gate. Progress {papers}/3.

+ [Back to your cell] -> Cell


// =====================================================================
//  ESCAPE MENU
// =====================================================================

=== Escape_Menu ===
Every way out of Blackmoor, as far as you can tell.

+ { strength >= 8 && ((inventory ? SharpenedSpoon) || (inventory ? Crowbar)) } [The east wall] -> Route_Wall
+ { strength >= 4 && ((inventory ? Spoon) || (inventory ? SharpenedSpoon) || (inventory ? MetalFile)) } [The tunnel] -> Route_Tunnel
+ { strength >= 6 && (inventory ? Rope) } [The rooftop] -> Route_Rooftop
+ { vell >= 4 && cigarettes >= 8 } [The bribe] -> Route_Bribe
+ { (inventory ? GuardUniform) && (inventory ? Keycard) } [The uniform] -> Route_Uniform
+ { intelligence >= 7 && ((inventory ? Paper) || (inventory ? ForgedPapers)) } [The forged release order] -> Route_Papers
+ [Not yet] -> Cell


// ---------------------------------------------------------------------
//  ROUTE 1 — THE EAST WALL
// ---------------------------------------------------------------------

=== Route_Wall ===
~ actions = actions - 1
The east wall of the shower block is old masonry, and old masonry leaks.
{ wall == 0 && loose_bar:
    You start at the bar you loosened and work outward from there.
    ~ wall = wall + 1
}
{ inventory ? Crowbar:
    The crowbar bites into the mortar and the whole wall complains.
- else:
    The sharpened spoon is a poor tool for stone, but it is a tool.
}
~ wall = wall + 1
{ wall >= 4:
    -> End_Wall
}
Stone dust on the floor. Pack it into the drain. Progress {wall}/4.
~ heat = heat + 1
{ heat >= 9:
    -> Caught
}
-> End_Action


// ---------------------------------------------------------------------
//  ROUTE 2 — THE TUNNEL
// ---------------------------------------------------------------------

=== Route_Tunnel ===
~ actions = actions - 1
You lift the third tile and go back to work on the drain bed. Water, grit, and the smell of the whole prison.
~ tunnel = tunnel + 1
{ tunnel >= 6:
    -> End_Tunnel
}
Progress {tunnel}/6. You pack the spoil into your mattress ticking.
~ heat = heat + 1
{ heat >= 9:
    -> Caught
}
-> End_Action


// ---------------------------------------------------------------------
//  ROUTE 3 — THE ROOFTOP
// ---------------------------------------------------------------------

=== Route_Rooftop ===
~ actions = actions - 1
You wait for the two a.m. count to pass, then go up the laundry chimney on twelve feet of braided bedsheet.

{ strength >= 9:
    -> End_Rooftop
}

~ temp roll = RANDOM(1, 10)
{ roll <= strength:
    -> End_Rooftop
}

Your foot finds nothing. The rope burns through your palms and you hit the roof of the boiler house hard.
~ heat = heat + 2
{ heat >= 9:
    -> Caught
}
-> End_Action


// ---------------------------------------------------------------------
//  ROUTE 4 — THE BRIBE
// ---------------------------------------------------------------------

=== Route_Bribe ===
~ actions = actions - 1
Vell is on the night gate with a paperback and a bad attitude.

{ vell >= 4 && cigarettes >= 8:
    ~ cigarettes = cigarettes - 8
    -> End_Bribe
}

You've misread her. She walks you back to your cell without a word.
~ vell = vell - 1
-> End_Action


// ---------------------------------------------------------------------
//  ROUTE 5 — THE UNIFORM
// ---------------------------------------------------------------------

=== Route_Uniform ===
~ actions = actions - 1
You put on the captain's uniform and button it to the throat. The keycard is cold in your palm.

{ (inventory ? Shank) && charisma < 6:
    You put the shank against the gate guard's kidney and tell him to open it. He opens it.
    -> End_Uniform
}

{ charisma >= 6:
    "Evening, Captain."
    "Evening." You don't stop walking. You don't look up. You don't run.
    -> End_Uniform
}

"Hold on. I don't know you."
Hands. Truncheons. The uniform goes in the incinerator.
~ inventory -= GuardUniform
~ heat = heat + 4
{ heat >= 9:
    -> Caught
}
-> End_Action


// ---------------------------------------------------------------------
//  ROUTE 6 — THE FORGED ORDER
// ---------------------------------------------------------------------

=== Route_Papers ===
~ actions = actions - 1

{ inventory ? ForgedPapers:
    -> Present_Papers
}

You sit with the stolen letterhead and a stolen pen, copying the Warden's signature until your hand cramps.
~ papers = papers + 1
{ papers >= 3:
    ~ inventory -= Paper
    ~ inventory += ForgedPapers
    The ink is dry. It looks like a transfer order signed by a man who has never once been questioned.
- else:
    It looks wrong. It looks like a prisoner copied a signature. Progress {papers}/3.
}
~ heat = heat + 1
-> End_Action

=== Present_Papers ===
You walk to the gate with the order folded in your breast pocket and your heart going like a bird in a box.

{ charisma >= 4:
    -> End_Papers
}

"Signed by the Warden, is it? I'll just call up and confirm."
The phone comes off the hook. You don't wait to hear the answer.
~ inventory -= ForgedPapers
~ heat = heat + 3
{ heat >= 9:
    -> Caught
}
-> End_Action


// =====================================================================
//  ENDINGS
// =====================================================================

=== End_Wall ===
The wall comes out in one piece at four in the morning, and the hole behind it is full of cold air that smells like nothing you've smelled in years.

You are through before the tower light swings back around. Behind you, Blackmoor gets smaller, and then it is only a shape on a hill, and then it is only weather.

ESCAPED — Day {day}, through the east wall.
-> END

=== End_Tunnel ===
The drain gives way at the sixth night and you come up in a field of wet barley a hundred yards outside the perimeter fence.

You lie on your back in the dark with mud in your teeth and laugh until your ribs hurt.

ESCAPED — Day {day}, through the tunnel.
-> END

=== End_Rooftop ===
You come over the last parapet with your palms ruined and the whole prison laid out under you like a board game.

The outer wall is a formality after that. You drop into the road, roll, and walk. You don't run. You never run.

ESCAPED — Day {day}, over the roof.
-> END

=== End_Bribe ===
Vell takes the cigarettes, checks her watch, and turns her back on the gate for exactly ninety seconds.

When she turns around there is nobody on the road.

ESCAPED — Day {day}, bought and paid for.
-> END

=== End_Uniform ===
Nobody stops a captain. That's the whole trick, and it isn't even a trick.

You walk out through the vehicle gate past two men who wish you a good evening.

ESCAPED — Day {day}, wearing their own coat.
-> END

=== End_Papers ===
The gate guard reads the order twice, shrugs, and lifts the barrier. You drive out in a supply van with a forged signature in your pocket and a straight face.

You don't look at the mirror until you're three miles out.

ESCAPED — Day {day}, on paper.
-> END


// =====================================================================
//  SYSTEMS
// =====================================================================

=== Caught ===
Truncheons. A black hood. Two days in the hole with the light on and nothing to count but the light.

They take nothing — they just want you to know they can.

~ heat = 0
~ day = day + 2
~ actions = 3
-> Cell

=== End_Action ===
{ actions > 0:
    -> Cell
}
-> Night

=== Night ===
~ day = day + 1
~ actions = 3
{ heat > 0:
    ~ heat = heat - 1
}
-> Night_Event

=== Night_Event ===
~ temp r = RANDOM(1, 6)
{ r == 1: Somewhere down the row a man cries in his sleep and nobody says anything about it. }
{ r == 2: The pipes tick in the wall. You count them instead of sheep. }
{ r == 3: A trusty walks the row with a torch, and the light goes across your face and moves on. }
{ r == 4: You dream about the gate and wake up with your hands already raised. }
{ r == 5: The window is grey with frost. Winter is coming, and winter means fewer eyes on the yard. }
{ r == 6: Someone in D-block gets a visit and comes back with cigarettes. Everyone is friendlier for a day. }
-> Cell