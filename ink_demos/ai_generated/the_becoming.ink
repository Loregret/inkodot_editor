// ============================================
// THE HOLLOW CROWN
// A Horror Adventure in Ink
// ============================================

VAR player_class = ""
VAR player_name = "the stranger"
VAR captain_alive = true
VAR kabenor_trust = 0
VAR mercs_alive = 5
VAR has_torch = true
VAR found_secret_passage = false
VAR warned_about_gold = false
VAR stopped_merc = false
VAR knows_kabenor_secret = false
VAR combat_skill = 5
VAR cunning = 5
VAR magic = 5

-> intro

// ============================================
// INTRODUCTION
// ============================================

=== intro ===
// CLASS SELECTION
The rain hammers against the stone archway as you descend into darkness. The catacombs stretch before you—ancient, forgotten, and hungry.

You are a sellsword, one of many hired for this expedition. But unlike the others, you have... talents.

What manner of warrior are you?

* [Warrior - Master of blade and shield]
    ~ player_class = "warrior"
    ~ combat_skill = 8
    ~ cunning = 3
    ~ magic = 2
    -> class_warrior

* [Rogue - Shadow and subtlety are your weapons]
    ~ player_class = "rogue"
    ~ combat_skill = 4
    ~ cunning = 8
    ~ magic = 3
    -> class_rogue

* [Wizard - Arcane knowledge flows through you]
    ~ player_class = "wizard"
    ~ combat_skill = 3
    ~ cunning = 5
    ~ magic = 8
    -> class_wizard

* [Bard - Words cut deeper than any blade]
    ~ player_class = "bard"
    ~ combat_skill = 4
    ~ cunning = 7
    ~ magic = 5
    -> class_bard

=== class_warrior ===
You've spilled more blood than most armies see in a lifetime. Your muscles remember every fight, every parry, every killing blow.

The other mercenaries give you a respectful nod. They know a killer when they see one.

-> meeting_kabenor

=== class_rogue ===
You've survived by being unseen, unheard, and unremembered—until the knife slides home.

The shadows feel like old friends. In a place like this, that might just keep you alive.

-> meeting_kabenor

=== class_wizard ===
The arcane arts are feared for good reason. You've glimpsed things beyond the veil—things that would shatter lesser minds.

But this place... something here is wrong. The very air hums with malevolent power.

-> meeting_kabenor

=== class_bard ===
Your tongue has talked you out of more graves than your blade ever could. Words are your weapons, stories your armor.

And every good story needs a foolhardy quest into certain death. This one is already writing itself.

-> meeting_kabenor

// ============================================
// MEETING THE PARTY
// ============================================

=== meeting_kabenor ===
// THE DESCENT BEGINS
Your boots squelch through centuries of decay as you follow the others. The tunnel opens into a wide chamber lit by sputtering torches.

A massive figure stands at the entrance—Captain Brakestorm. Silver-haired and grizzled, a leather patch covers one empty socket. His remaining eye sweeps over you like a blade.

"So you're the last one," he rumbles. "Hope you're worth the coin."

Behind him, five other mercenaries check their gear. They look... experienced. And nervous.

At the far end of the chamber stands a figure in a deep hood. Long brown hair spills over his shoulders, and a thick beard obscures his face. But his eyes—pale and wrong—glow faintly in the torchlight.

Kabenor. The client.

He speaks, and his voice echoes strangely.

"The deepest chamber. You will escort me there. Touch nothing. Speak to no spirits. And do not... wander."

* {player_class == "wizard"} [Ask about the malevolent aura]
    -> wizard_question

* {player_class == "bard"} [Charm the mercenaries]
    -> bard_charm

* [Stay silent and observe]
    -> observe_party

* [Ask Captain Brakestorm about the mission]
    -> ask_captain

=== wizard_question ===
You feel the arcane energy practically bleeding from Kabenor. This is no ordinary tomb.

"What manner of place is this?" you ask carefully. "The spirits here are... agitated."

Kabenor turns his head slowly, like a predator acknowledging prey.

"A resting place. Nothing more. Keep your questions to yourself, spellcaster."

~ kabenor_trust -= 1
Captain Brakestorm grunts. "Mind your tongue. We're paid to walk, not think."

-> observe_party

=== bard_charm ===
You sidle up to the mercenaries with an easy smile.

"Quite a crew for a simple tomb walk. Been on many expeditions like this?"

The youngest—a woman with scarred arms named Mira—shakes her head. "Never seen coin this good for a catacomb job. Either Kabenor's desperate or he's hiding something."

"Or both," mutters Gareth, a balding man with nervous eyes.

~ knows_kabenor_secret = true
The others nod grimly.

-> observe_party

// ============================================
// PARTY HUB — QOL MENU
// ============================================

=== observe_party ===
You take stock of your companions. Before you press on, you have a moment to study each of them.

* [Study Captain Brakestorm]
    -> party_brakestorm
* [Study Gareth]
    -> party_gareth
* [Study Sylas]
    -> party_sylas
* [Study Mira]
    -> party_mira
* [Study Dorn]
    -> party_dorn
* [Study Vex]
    -> party_vex
* [Study Kabenor]
    -> party_kabenor
* [Move on]
    -> ask_captain

=== party_brakestorm ===
Captain Brakestorm. One eye, silver hair, built like a siege tower. He's done this before—you can tell by the way he never looks at the same shadow twice.

His hand never strays far from his axe. His voice is a rumble that carries without effort.

He's the kind of man who's buried a lot of friends, and buried them deep. You don't want to be the next one.

-> observe_party

=== party_gareth ===
Gareth. Balding, twitchy. His crossbow is loaded and his nerve is shot.

He keeps glancing back the way you came. His hands won't stop moving—checking his string, his bolts, his bootlaces. Anything to avoid looking into the dark.

He's the kind of man who's already decided he's going to die down here.

-> observe_party

=== party_sylas ===
Sylas. Young, handsome, too confident. He wears his sword like a decoration and his smile like armor.

He's the type who either dies first, or becomes the type who makes others die first. You haven't decided which yet.

-> observe_party

=== party_mira ===
Mira. Scarred arms, haunted eyes. She's killed before, and it haunts her. That's a good sign—it means she still has a conscience.

She doesn't say much. When she does, people listen.

-> observe_party

=== party_dorn ===
Dorn. Silent, hulking. He carries a shield the size of a door and says nothing.

Nobody knows his story. Nobody asks. He's the kind of man who's useful to have between you and whatever's trying to kill you—and he seems content with that arrangement.

-> observe_party

=== party_vex ===
Vex. A woman with sharp features and sharper knives. She watches everyone, including you.

Her eyes are cold and calculating. She's measuring you, weighing you, deciding whether you're a threat or an asset.

You get the sense she's already decided which of the others she'd be willing to sacrifice.

-> observe_party

=== party_kabenor ===
Kabenor. The client. Long brown hair, thick beard, and eyes that glow faintly in the torchlight.

He doesn't speak much. When he does, his voice echoes strangely—as if it's coming from somewhere deeper than his chest.

He knows this place. He knows it well. And he's not telling anyone why.

-> observe_party

=== ask_captain ===
You fall into step beside Captain Brakestorm as the party descends into darkness.

"You've led expeditions like this before," you say quietly.

"Aye." He doesn't look at you. "Usually we know what we're looking for. This one just says 'deepest chamber' and pays triple. I don't like it."

"Then why take the job?"

He grunts. "Because triple coin buys a lot of ale. And I've seen too many things to believe in curses."

He pauses, then adds, "But I've buried too many good men to ignore bad feelings, either. Keep your head on a swivel."

~ kabenor_trust += 1

-> encounter_undead

// ============================================
// ENCOUNTER 1: THE UNDEAD
// ============================================

=== encounter_undead ===
// THE HUNGRY DEAD
The tunnel descends sharply. The air grows cold—impossibly cold. Your breath fogs before your face.

Then you hear it. A wet, dragging sound. And another. And another.

Captain Brakestorm holds up his fist. The party stops.

"Something ahead," he whispers. "Lots of somethings."

He turns to you. "You. Scout ahead. Prove you're worth your coin."

* {player_class == "rogue"} [Move silently ahead]
    -> scout_stealth

* [Move forward cautiously]
    -> scout_carefully

* [Refuse - it's suicide]
    -> refuse_scout

* [Suggest lighting more torches first]
    -> suggest_torches

=== scout_stealth ===
You melt into the shadows like you were born in them. Your footsteps make no sound.

Ahead, the tunnel opens into a burial chamber. Bodies—dozens of them—lie in alcoves carved into the walls. But they're moving. Twitching. Rising.

The dead are waking.

You count them: at least fifteen, maybe more. They haven't noticed you yet. There's a side passage to the left that they seem to avoid—perhaps a way around?

~ cunning += 2
~ found_secret_passage = true
You slip back to the party.

"Undead ahead. A dozen or more. But there's a side passage they're avoiding. Could be a way around, or a trap."

-> undead_planning

=== scout_carefully ===
You creep forward, sword drawn. The tunnel opens into a burial chamber.

The dead are rising. Withered hands claw at the air. Empty eye sockets turn toward you.

One sees you.

It screams—a sound like tearing metal—and the others join in. They're coming!

You sprint back to the party.

"Undead! They saw me! They're coming!"

Captain Brakestorm curses. "Form up! Weapons ready!"

-> undead_fight

=== refuse_scout ===
Captain Brakestorm's eye narrows dangerously.

"You refuse?"

"I'm not dying for your coin," you say flatly. "Send someone else."

For a long moment, you think he might kill you himself. Then he spits on the ground.

"Vex. Go."

Vex slips ahead. Minutes pass. Then she returns, pale-faced.

"Undead. Lots. We need to fight or run."

~ kabenor_trust -= 2
~ combat_skill += 1
~ cunning += 1
"You should have gone," Brakestorm mutters. "Could have used that information sooner."

-> undead_planning

=== suggest_torches ===
"More light first," you say. "Fighting the dead in darkness is suicide."

Captain Brakestorm considers this, then nods. "Smart. Gareth, Sylas—light more torches."

The party advances with proper illumination. When the undead attack, you're ready.

~ combat_skill += 1
-> undead_fight

=== undead_planning ===
// PREPARING FOR BATTLE
Captain Brakestorm gathers the party.

"We can fight through, or we can look for another way. What say you?"

Kabenor steps forward, his pale eyes gleaming. "We go through. My destination lies beyond."

"You'll get us killed," Mira mutters.

"Then don't die," Kabenor replies coldly.

* [Fight through the undead]
    -> undead_fight

* {found_secret_passage} [Take the side passage]
    -> secret_passage

* {player_class == "wizard"} [Try to bind the undead with magic]
    -> wizard_bind

* {player_class == "bard"} [Try to intimidate the undead]
    -> bard_intimidate

=== wizard_bind ===
You raise your hands, arcane words spilling from your lips. The air grows thick with power.

The dead hesitate. Their movements slow. Some stop entirely.

But there are too many. You can feel your magic fraying at the edges, the undead fighting your control.

"Now!" you shout. "While they're held!"

The party charges. You break through the horde before your spell fails, but not before one of them sinks its teeth into Sylas's arm.

~ mercs_alive -= 1
~ magic -= 2
Sylas screams as the wound turns black. By the time you reach safety, he's dead.

Captain Brakestorm kneels beside the body, closing Sylas's eyes.

"One down," he says grimly. "Keep moving."

-> bone_colossus

=== bard_intimidate ===
You step forward, raising your voice above the moans of the dead.

"Listen to me, restless spirits! We mean no desecration! Let us pass, or face annihilation!"

Some of the undead pause. Their hollow eyes turn toward you.

Then Kabenor pushes past you. "Fool. They don't understand mercy."

He raises a hand. Dark energy pulses outward. The undead scream and fall back, writhing.

"What... what did you do?" Gareth whispers.

"Just walk," Kabenor says.

~ kabenor_trust -= 1
~ knows_kabenor_secret = true
The party hurries through the chamber. Whatever Kabenor is, he's no ordinary man.

-> bone_colossus

=== undead_fight ===
// BATTLE WITH THE DEAD
The undead surge forward—a tide of rotting flesh and ancient hate.

Captain Brakestorm roars and swings his axe, cleaving two of them in half. You fight back-to-back with Dorn, his shield protecting you both.

Gareth's crossbow sings. Mira screams as one drags her down—Dorn pulls her free at the last moment.

The battle is chaos. Your arm grows tired. Your sword grows heavy.

* {combat_skill >= 6} [Press the attack - cut a path through!]
    -> fight_press

* {cunning >= 6} [Look for a weakness in their formation]
    -> fight_weakness

* {player_class == "wizard"} [Use magic to destroy them]
    -> fight_magic

* {player_class == "warrior"} [Rally the party and charge!]
    -> fight_rally

* [Retreat - this is unwinnable]
    -> fight_retreat

=== fight_press ===
You become death itself. Your blade sings through rotting flesh, scattering bones and dust.

The undead fall before you, but they keep coming. You're deep in the horde now—cut off from the others.

{combat_skill >= 7:
    You fight your way back to the party, cutting a path through the dead. The last of the undead falls. You're wounded, but alive.

    ~ combat_skill -= 2
    Captain Brakestorm finds you leaning against the wall.

    "Impressive. Stupid, but impressive." He wraps your wound. "Let's move."
- else:
    A hand claws at your back. Teeth sink into your shoulder.

    You scream and spin, cutting down your attacker, but more are coming. Too many.

    Then Captain Brakestorm is there, axe swinging, cutting a path through the dead.

    "MOVE!" he roars.

    You run. He follows—but a spear of bone catches him in the back.

    He falls.

    ~ captain_alive = false
    ~ mercs_alive -= 1
    You drag him clear of the horde. He's still breathing, but barely.

    "Leave me," he rasps. "Finish the job."

    The others gather around. Mira kneels beside him.

    "We can't just—"

    "You can. And you will." He coughs blood. "The mission... matters."

    He dies before you can argue.

    ~ combat_skill += 1
    You take his axe. It feels heavier than it should.
}
-> bone_colossus

=== fight_weakness ===
You notice something: the undead avoid the corners of the chamber. The shadows. They stay in the torchlight.

"They fear the dark," you realize. "Or something in it."

You lead the party toward the shadows. The undead retreat, hissing.

Kabenor watches you with interest. "Clever."

~ cunning += 2
You pass through unharmed. Whatever waits in the darkness, it doesn't bother you tonight.

-> bone_colossus

=== fight_magic ===
You draw upon the arcane, shaping fire from nothing. The flames roar outward, consuming the undead like dry kindling.

They shriek and burn. Some flee. Most crumble to ash.

But the effort costs you. A nosebleed begins, and your head pounds with the strain.

~ magic -= 3
~ combat_skill += 1
Captain Brakestorm nods respectfully. "Useful tricks you have."

Kabenor says nothing, but his eyes follow you more closely now.

-> bone_colossus

=== fight_rally ===
You leap onto a fallen pillar, raising your sword high.

"Stand together! We are warriors, not prey! Face them with steel and fire!"

The party roars in response. Even Gareth stops trembling.

You charge as one—six warriors against a horde. The undead don't stand a chance.

~ combat_skill += 2
~ mercs_alive += 1
When the last one falls, Captain Brakestorm claps you on the shoulder hard enough to bruise.

"Well fought."

-> bone_colossus

=== fight_retreat ===
You run. The others follow.

But the undead are faster than they look. One of them catches Gareth, dragging him down.

You don't look back. You can't.

When you finally stop, only five of you remain: you, Brakestorm, Dorn, Mira, Vex—and Kabenor, who watched the slaughter without lifting a finger.

~ mercs_alive -= 1
Captain Brakestorm glares at you. "We don't leave our dead."

"We do when staying means joining them," you reply.

He doesn't argue. But something in his eye has changed.

-> bone_colossus

=== secret_passage ===
// THE HIDDEN PATH
You lead the party to the side passage. It's narrow, dark, and smells of old blood.

"After you," Captain Brakestorm says, eyeing the darkness.

You enter first. The passage winds downward, rough-hewn and ancient. No undead follow. They either don't know about it, or fear what's inside.

* {cunning >= 6} [Search for traps as you go]
    -> secret_careful

* {player_class == "rogue"} [Move silently and check ahead]
    -> secret_stealth

* [Just hurry through]
    -> secret_hurry

=== secret_careful ===
You move slowly, checking every stone. Good thing, too—the passage is riddled with pressure plates and hidden wires.

You disarm a dart trap and a collapsing ceiling trap before anyone gets hurt.

Captain Brakestorm watches you work. "Not bad. You've done this before."

"Once or twice."

Kabenor says nothing, but you notice he avoids looking at the walls. At the carvings.

-> bone_colossus

=== secret_stealth ===
You ghost ahead, checking the passage for dangers. Your sharp eyes catch tripwires, pressure plates, and a hidden pit.

You guide the party through safely.

When you emerge on the other side, Vex gives you a nod of respect.

"You're not entirely useless," she says. Coming from her, that's a compliment.

~ cunning += 2
-> bone_colossus

=== secret_hurry ===
You move quickly, wanting to be free of this place.

Too quickly.

The floor clicks under your boot. A pressure plate.

Before you can shout a warning, the ceiling collapses. Dorn shoves you aside, taking the falling stones himself.

When the dust clears, Dorn is dead.

Captain Brakestorm kneels beside him, silent. Then he stands.

"We keep moving."

~ mercs_alive -= 1
-> bone_colossus

// ============================================
// ENCOUNTER 2: THE BONE COLOSSUS
// ============================================

=== bone_colossus ===
// THE BONE COLOSSUS
The passage widens into a cathedral of bone. Ribs arch overhead like vaulting. Skulls are stacked in alcoves like candles.

In the center, something rises.

It's built from hundreds of bodies—a giant of bone and sinew and green fire. A colossus. Its skull-face turns toward you, and the fire in its sockets brightens.

Kabenor speaks without turning. "Do not let it touch the walls. It draws strength from the dead."

{captain_alive:
    Captain Brakestorm grunts. "Eyes forward. We've killed worse."
- else:
    Nobody answers. The captain's absence is a weight on everyone's shoulders.
}

* {combat_skill >= 7} [Charge it head-on]
    -> colossus_charge

* {cunning >= 6} [Study it for a weakness]
    -> colossus_weakness

* {player_class == "wizard"} [Scan it for magic]
    -> colossus_magic

* {player_class == "rogue"} [Slip behind it]
    -> colossus_flank

* [Try to sneak the party past it]
    -> colossus_sneak

* [Retreat - find another way]
    -> colossus_retreat

=== colossus_charge ===
You charge.

The colossus swings a fist the size of a cart. You duck, roll, come up swinging. Your blade bites into its shin—and shatters bone. It staggers.

But it doesn't fall. It never falls. It simply reforms.

{combat_skill >= 8:
    You keep swinging, keep moving, until you find the seam. There—at the base of its spine, a single skull glows brighter than the rest.

    You drive your blade into it.

    The colossus screams—a thousand voices at once—and collapses into a heap of bones.

    ~ combat_skill += 1
    You stand in the rubble, breathing hard.

    {captain_alive:
        Captain Brakestorm nods at you. "Good. Very good."
    - else:
        Mira nods at you. "Good. Very good."
    }
- else:
    The colossus catches you in its grip. Bone fingers close around your ribs.

    You hear them crack.

    ~ combat_skill -= 3

    Someone is shouting. Blades flash. The colossus drops you—Mira has driven her sword into its knee.

    You crawl clear, gasping. The colossus turns toward her.

    She doesn't make it.

    ~ mercs_alive -= 1
    When the colossus finally falls, you're too broken to feel relief.
}
-> sealed_door

=== colossus_weakness ===
You don't charge. You watch.

The colossus moves slowly. Too slowly. And every time it steps, the bones in its chest shift—and for just a moment, you see a light beneath them. A single skull, glowing green.

That's the heart. That's the weakness.

"Its chest!" you shout. "There's a glowing skull—that's where it draws power!"

{captain_alive:
    Brakestorm nods grimly. "Then we take it out. On my count."
    The two of you charge together. You draw its attention, and he drives his axe into its chest. The bone shatters. The glowing skull cracks.

    The colossus falls apart. But not before it swings one last time—and catches Vex across the shoulder. She survives. Barely.
- else:
    Mira nods grimly. "Then we take it out. Together."
    You and Mira charge as one. She draws its attention, and you drive your blade into its chest. The bone shatters. The glowing skull cracks.

    The colossus falls apart. But not before it swings one last time—and catches Dorn across the shoulder. He survives. Barely.
}

~ cunning += 2
~ combat_skill += 1
-> sealed_door

=== colossus_magic ===
You reach out with your senses. The colossus is held together by a binding spell—old, powerful, but crude. There's a flaw in it: a single word that holds the whole thing together.

You can break it.

{magic >= 7:
    You shout the word of unbinding.

    The colossus stops. It shudders. And then it collapses—a thousand bones falling to the floor at once.

    ~ magic -= 2
    Kabenor looks at you with something like respect.

    "Impressive."
- else:
    You shout the word of unbinding.

    The colossus stops. It shudders. And then it keeps moving.

    The spell was too strong. You've only made it angry.

    ~ magic -= 2
    ~ combat_skill -= 1

    It charges. The party scatters. You hear a scream—one of the mercenaries, caught in its path.

    When it finally falls—to a dozen desperate blows—the mercenary is already dead.

    ~ mercs_alive -= 1
}
-> sealed_door

=== colossus_flank ===
You slip behind the colossus while the others draw its attention. Up close, you can see the seams—the places where the bones don't quite fit.

You find a gap at the base of its spine. A single skull, glowing brighter than the rest.

You drive your knife into it.

The colossus shudders. It doesn't fall—but its movement slows.

"NOW!" you shout. "While it's weak!"

The party charges. The colossus falls under a dozen blows.

~ cunning += 2
-> sealed_door

=== colossus_sneak ===
You gesture for silence. The party moves along the wall, slow, careful, not a single torch raised.

{cunning >= 7:
    The colossus doesn't notice. Its head turns slowly, but its eyes don't seem to focus. You make it through without a single blow.

    On the other side, Mira exhales. "Gods. I thought I was going to die."

    Kabenor says nothing. He's watching you more closely now.

    ~ cunning += 2
- else:
    The colossus doesn't notice—at first.

    Then one of the mercenaries' boots scrapes stone.

    Its head snaps toward them. And it charges.

    ~ mercs_alive -= 1
    You run. They don't.

    You escape into the next passage, hearts pounding. Behind you, something roars.
}
-> sealed_door

=== colossus_retreat ===
"No," you say. "We're not fighting that. Back. Back the way we came."

{captain_alive:
    Captain Brakestorm doesn't argue. He's already turning.
- else:
    The others follow you without a word.
}

You retreat into a side passage. The colossus doesn't follow—it's too big to fit.

But the side passage isn't a way forward. It's a dead end.

"We'll have to go through," someone says grimly. "Or we turn back entirely."

Nobody wants to turn back entirely.

* [Fight the colossus after all]
    -> colossus_weakness

* [Try the sneak again]
    -> colossus_sneak

// ============================================
// ENCOUNTER 3: THE SEALED DOOR
// ============================================

=== sealed_door ===
// THE SEALED DOOR
The passage ends at a door of black stone. Three symbols are carved into it: a sun, a skull, and a weeping eye.

Below the symbols, three stone buttons.

Kabenor stops. "The order matters. Press wrongly, and we'll wish the colossus had killed us."

"How do we know the order?" someone asks.

* {cunning >= 7} [Search the walls for clues]
    -> door_clues

* {player_class == "wizard"} [Read the symbols magically]
    -> door_magic

* {player_class == "bard"} [Decipher the symbols as a riddle]
    -> door_riddle

* {kabenor_trust >= 2} [Ask Kabenor - he must know]
    -> door_ask_kabenor

* [Guess - press at random]
    -> door_guess

=== door_clues ===
You examine the walls. The carvings here are older than the others—faded, but still legible.

They tell a story: the sun rises over a city. At noon, the city is full of the living. At dusk, a skull appears—death. At night, a weeping eye—mourning.

The sun. The skull. The weeping eye.

You press the buttons in that order.

The door grinds open.

~ cunning += 2
-> door_open

=== door_magic ===
You reach out with your senses. The door has no lock—only a test. A test of understanding.

The symbols aren't random. They're a sequence: life, death, mourning. The sun is life. The skull is death. The eye is what comes after.

You press: sun, skull, eye.

The door opens.

~ magic -= 1
~ cunning += 1
-> door_open

=== door_riddle ===
You study the symbols. A sun, a skull, an eye.

"It's a riddle," you murmur. "Life, death, and what follows. The sun rises. The skull rules. The eye weeps."

You press them in order.

The door opens.

~ cunning += 1
-> door_open

=== door_ask_kabenor ===
You turn to Kabenor. "You know this place. What's the order?"

He studies you for a long moment. Then he nods—slowly, as if he's decided you're worth helping.

"Sun. Skull. Eye. Life, death, mourning. The story of every soul."

You press the buttons.

The door opens.

~ kabenor_trust += 1
-> door_open

=== door_guess ===
You don't wait. You press: skull, eye, sun.

For a moment, nothing happens.

Then the door shudders. A crack opens in the stone, and a wave of green gas pours out.

The party scatters, coughing. One of the mercenaries isn't fast enough. By the time the gas clears, they're dead.

~ mercs_alive -= 1
{captain_alive:
    Captain Brakestorm glares at you. "Never do that again."
- else:
    Mira glares at you. "Never do that again."
}

The door is open now—but the cost was high.

-> door_open

=== door_open ===
Beyond the door, the passage continues. But the air is different here—thicker. Warmer. Like something is breathing.

Kabenor walks through without hesitation.

"Come. We're close now."

-> whispering_dark

// ============================================
// ENCOUNTER 4: THE WHISPERING DARK
// ============================================

=== whispering_dark ===
// THE WHISPERING DARK
The passage narrows until you're walking single file. The torches gutter. The dark presses in.

Then the whispers start.

Your name. Said softly, like a lover. Then again. Then a hundred voices at once, each one knowing something they shouldn't.

"I know what you did."
"I know what you want."
"I know what you'll become."

The mercenaries stop. Hands go to weapons. Some of them are weeping.

Kabenor watches, impassive.

* [Press on - ignore the voices]
    -> whisper_press

* {player_class == "wizard"} [Shield your mind with magic]
    -> whisper_shield

* {player_class == "bard"} [Answer the voices - sing them down]
    -> whisper_sing

* [Listen - try to learn something]
    -> whisper_listen

* [Turn back]
    -> whisper_back

=== whisper_press ===
You grit your teeth and walk.

The whispers grow louder. They say things about you—things you'd never admit, things you'd almost forgotten. You keep walking.

{cunning >= 6:
    One by one, the others follow. The whispers fade as you move. By the time you reach the end of the passage, the silence is a relief.

    {captain_alive:
        Captain Brakestorm claps you on the shoulder. "Good nerve."
    - else:
        Mira claps you on the shoulder. "Good nerve."
    }

    ~ combat_skill += 1
- else:
    You make it. But not everyone does.

    Behind you, a scream. You turn—one of the mercenaries has dropped their weapon and is clawing at their own ears. They run back the way you came.

    They don't come back.

    ~ mercs_alive -= 1
}
-> whisper_end

=== whisper_shield ===
You raise a shield of will—an old wizard's trick, woven from focus and memory.

The whispers break against it like waves on stone.

{magic >= 6:
    You extend the shield to cover the others. It's exhausting, but it holds.

    ~ magic -= 2
    You walk through the passage in silence. Kabenor watches you the whole way.

    "You have more discipline than most," he says quietly.

    ~ kabenor_trust += 1
- else:
    The shield holds for you—barely. But it doesn't cover the others.

    ~ magic -= 2
    You hear the whispers reaching them. You hear them start to scream.

    ~ mercs_alive -= 1
    One of them doesn't come out.
}
-> whisper_end

=== whisper_sing ===
You sing.

You don't know why. It's the oldest instinct you have—the bard's instinct. You raise your voice, and you sing something old, something true.

The whispers pause.

Then they answer. They sing back. A thousand voices in harmony, and for a moment, the darkness isn't frightening at all. It's beautiful.

You understand, then. The dead aren't angry. They're lonely.

You keep singing until you reach the other side. The others follow, silent, safe.

~ cunning += 2
Kabenor looks at you with something that might be respect.

"Interesting."

-> whisper_end

=== whisper_listen ===
You stop. You listen.

The whispers crowd in, eager.

"Kabenor is not what he seems."
"Kabenor seeks the crown."
"Kabenor will become the crown."

You hear other things too—things about yourself. Things you'd rather not know.

{cunning >= 7:
    You sift the whispers for truth. Most of it is madness. But some of it is real.

    You learn what Kabenor is. What he's planning. What waits at the bottom of the catacombs.

    ~ knows_kabenor_secret = true
    ~ cunning += 2
    You pull back before the whispers can take hold.
- else:
    You listen too long.

    ~ combat_skill -= 2
    ~ cunning -= 1
    The whispers find the cracks in you. They pour in. When you finally shake them off, you're shaking, and you've bitten through your lip.

    You don't know if what you heard was true. You don't know if it matters.

    But you can't unhear it.
}
-> whisper_end

=== whisper_back ===
"No," you say. "We're not going through that."

"There's no other way," someone says.

"Then we make one."

You turn back—and the whispers follow. They don't stop. They never stop.

{cunning >= 6:
    You find a side passage, narrow but passable. It bypasses the whispering dark entirely.

    It costs you time. It costs you torches. But you make it through.
- else:
    You don't find a way around. You find a dead end.

    And the whispers find you.

    ~ mercs_alive -= 1
    By the time you turn back and push through the dark, one of the mercenaries has been lost to madness—they walked into the dark and never came out.
}
-> whisper_end

=== whisper_end ===
The passage opens. The whispers fade behind you, like a memory you can't quite shake.

Ahead, another corridor waits.

-> traps_section

// ============================================
// ENCOUNTER 5: THE PUZZLE CORRIDOR
// ============================================

=== traps_section ===
// THE PUZZLE CORRIDOR
The party emerges into a corridor unlike the rest—worked stone, perfectly smooth, with no dust or debris.

Kabenor stops at the threshold.

"The architect of this place was fond of games," he says. "Tread carefully."

Captain Brakestorm studies the floor. "Can't see any trigger mechanisms. You two—" he points at you and Vex "—find us a way through."

* {player_class == "rogue"} [Examine the walls for mechanisms]
    -> trap_walls

* {cunning >= 6} [Study the floor pattern]
    -> trap_floor

* {player_class == "wizard"} [Detect magical traps]
    -> trap_magic

* [Test the first tile with a pole]
    -> trap_pole

* [Walk confidently forward]
    -> trap_walk

* [Refuse to go first]
    -> trap_refuse

=== trap_walls ===
You examine the walls closely, running your fingers over the stone. There—a slight depression. And there—a discolored patch.

"The walls have mechanisms. Hidden panels." You trace the lines. "They're connected to the floor. If we step on the wrong tile, we trigger them."

"Which tiles are safe?"

"Give me a moment."

~ cunning += 2
You study the pattern and identify a safe path zigzagging through the corridor.

"Follow me exactly. Don't step anywhere I don't step."

-> trap_crossing

=== trap_floor ===
You kneel, studying the floor tiles. They're all slightly different—some darker, some lighter, some with subtle variations in the grout.

"There's a pattern," you realize. "The darker tiles are safe. The lighter ones trigger the traps."

"You sure?"

"Trust me."

You lead the party across, stepping only on the darker stones. It works—barely. Twice you hear mechanisms click and whirr before falling silent.

-> trap_crossing

=== trap_magic ===
You extend your senses, feeling for magical energy. The corridor lights up in your mind's eye—a lattice of traps, spells, and enchantments.

"The floor has pressure plates. The walls have darts. The ceiling has... something worse. But there's a path."

You trace it with your finger. "Follow me. Don't deviate."

~ magic -= 2
~ cunning += 1
-> trap_crossing

=== trap_pole ===
You grab a spear from one of the mercenaries and poke the first tile.

Nothing happens.

You poke the next one. A blade swings down from the ceiling, slicing the spear in half.

"Not that one," you say.

"What now?"

"We figure out the pattern."

~ cunning += 1
-> trap_floor

=== trap_walk ===
You stride forward confidently, trusting your instincts.

The floor clicks. A blade swings down.

~ combat_skill -= 2
You dodge—barely—but the blade catches your shoulder, opening a deep gash.

Captain Brakestorm pulls you back. "Try again. Carefully this time."

~ cunning += 1
-> trap_floor

=== trap_refuse ===
"No," you say flatly. "I'm not walking into that."

"Then someone else will."

Mira steps forward. She studies the corridor, then begins crossing.

She makes it halfway before the floor drops out beneath her.

Her scream echoes for a long time.

~ mercs_alive -= 1
~ kabenor_trust -= 2
Kabenor examines the corridor himself, then points. "There. The pattern. Follow it."

He leads the party through without a single misstep.

-> trap_crossing

=== trap_crossing ===
// THROUGH THE GAUNTLET
The party makes it through the corridor, though the traps are not done with you.

* {cunning >= 8} [Use your knowledge to disarm the remaining traps]
    -> trap_disarm

* [Press forward quickly]
    -> trap_press

* [Take a moment to rest and heal]
    -> trap_rest

=== trap_disarm ===
You carefully disable each trap as you pass—pressure plates, dart mechanisms, even a magical rune that would have incinerated the entire party.

When you reach the end, Captain Brakestorm is watching you with grudging respect.

"You've saved us more than once. What's your name, stranger?"

You tell him.

He nods. "I'll remember it."

~ kabenor_trust += 1
~ combat_skill += 1
-> trap_reward

=== trap_press ===
You urge the party forward, not wanting to give the traps time to reset or reveal new dangers.

But haste breeds mistakes.

Gareth stumbles on a loose stone. A spear launches from the wall, piercing his chest.

He dies before he hits the ground.

~ mercs_alive -= 1
Captain Brakestorm closes his eyes for a moment. "Keep moving. We can't help him now."

-> trap_reward

=== trap_rest ===
You call for a halt. The party tends wounds, redistributes gear, and catches their breath.

During the rest, Kabenor approaches you.

"You are competent," he says quietly. "When we reach the deepest chamber, stay close. You may prove... useful."

~ kabenor_trust += 1
"Useful how?"

He smiles—a thin, cold expression. "You'll see."

-> trap_reward

=== trap_reward ===
At the end of the corridor, the party finds a small alcove with supplies—ancient but preserved: water, bandages, even a few vials of healing potion.

"Loot," Vex says, reaching for a vial.

* {cunning >= 6} [Stop her - it might be trapped]
    -> trap_stop

* [Let her take it]
    -> trap_take

=== trap_stop ===
You grab Vex's wrist before she touches the vial.

"Wait. Look at the dust pattern—nothing's disturbed except around this alcove. Someone else found this first, and left the potions. Why?"

Vex frowns. She examines the vial more closely, then curses.

"Poison. It's poisoned."

~ cunning += 2
Captain Brakestorm nods approvingly. "Good eyes."

The party moves on without taking anything.

-> treason_scene

=== trap_take ===
Vex grabs the vial and drinks it before anyone can stop her.

For a moment, nothing happens.

Then she begins to scream. Her skin bubbles. Her eyes melt. She collapses, twitching, and dies in seconds.

~ mercs_alive -= 1
Captain Brakestorm stares at the body. "Nobody else touches anything."

-> treason_scene

// ============================================
// ENCOUNTER 6: TREASON
// ============================================

=== treason_scene ===
// THE BROKEN COMPACT
The party emerges into a natural cavern—a resting place. Captain Brakestorm calls for a halt.

"We rest. Then we push to the deepest level."

Everyone settles in, but you notice something: some of the mercenaries are speaking quietly. They keep glancing at the captain. At Kabenor.

* {cunning >= 6} [Eavesdrop on the whispering mercs]
    -> treason_eavesdrop

* [Approach Captain Brakestorm]
    -> treason_captain

* [Confront the mercs directly]
    -> treason_confront

* [Ignore it and rest]
    -> treason_rest

=== treason_eavesdrop ===
You edge closer, pretending to adjust your gear.

"...not worth it. He's not telling us what's down there. Could be anything."

"The coin's good."

"Coin's worthless if we're dead."

"We take the captain's share, and Kabenor's... then we go."

"When?"

"Next rest stop. Or now. He's getting old. Slower."

~ cunning += 2
~ knows_kabenor_secret = true
You've heard enough. Some of the mercs are planning to rob the captain and abandon the mission.

You have a choice to make.

-> treason_choice

=== treason_captain ===
You approach Captain Brakestorm, who's studying a map by torchlight.

"Problem?" he asks without looking up.

"Some of the others are getting cold feet. Talking about cutting and running. Maybe worse."

He grunts. "I know. I've seen it before." He finally looks at you. "What about you? You loyal, or looking for an angle?"

* [Loyal - we finish this]
    "I finish what I start."
    ~ kabenor_trust += 1
    He nods slowly. "Good. Keep your weapon ready."
    -> treason_choice

* [Looking for an angle]
    "I'm looking out for myself. Like everyone else."
    He barks a laugh. "Honest. I can respect that. But cross me, and I'll bury you."
    -> treason_choice

=== treason_confront ===
You walk directly to the whispering mercs.

"Planning something?"

They freeze. One of them recovers first.

"Just talking about the mission. Getting harder than expected."

"Doesn't look like it."

Vex's hand drifts toward her knife. "You're not the captain. Back off."

~ cunning += 1
-> treason_choice

=== treason_rest ===
You find a corner and close your eyes, trying to rest.

It doesn't work. The tension in the cavern is thick enough to cut.

Something's about to happen. You can feel it.

-> treason_choice

=== treason_choice ===
{captain_alive:
    -> treason_captain_alive
- else:
    -> treason_captain_dead
}

=== treason_captain_alive ===
Captain Brakestorm stands, stretching his massive frame.

"Alright. Time to move."

That's when one of the mercenaries draws their blade.

"Sorry, Captain. But we're not dying for this lunatic's gold."

Three mercs stand with them—the ones who were whispering.

The remaining loyalists stand with the captain.

Weapons are drawn. Blood is about to spill.

* [Side with Captain Brakestorm - kill the traitors]
    -> side_captain

* [Side with the traitors - kill the captain]
    -> side_traitors

* {player_class == "bard"} [Try to negotiate peace]
    -> negotiate_peace

* {cunning >= 8} [Feign siding with traitors, then betray them]
    -> double_cross

=== side_captain ===
You draw your weapon and stand beside Captain Brakestorm.

"Traitors die," you say. "That's the rule."

Brakestorm grins—a wolf's expression. "I knew I liked you."

The battle is brutal but short. The traitors are skilled, but they're outnumbered and outmatched. Brakestorm fights like a man possessed, his axe carving through armor and bone.

When it's over, the traitors lie dead. The captain is wounded but alive.

~ mercs_alive -= 3
~ kabenor_trust += 2
Captain Brakestorm claps you on the shoulder.

"You saved my life. I won't forget it."

Kabenor watches the bodies with no expression. "Shall we continue?"

-> continue_after_treason

=== side_traitors ===
You draw your weapon and stand with the traitors.

"Sorry, Captain. But I'm not dying for this."

Brakestorm's eye widens—then hardens. "You'll regret this."

The battle is savage. Brakestorm fights like a demon, taking three traitors with him before he falls. His loyalists die defending him.

When it's over, only you, Vex, and one other traitor remain alive. Kabenor watched the whole thing without moving.

~ captain_alive = false
~ mercs_alive = 3
Vex spits on the captain's body. "Let's go. We're done here."

You leave the catacombs behind—or try to.

-> ghoul_attack

=== negotiate_peace ===
You step between the two groups, hands raised.

"Enough! We can settle this without bloodshed!"

"Get out of the way," someone growls.

"No. Listen to me." You look at the traitors. "You want to leave? Leave. But you don't need to kill anyone. And you—" you turn to Brakestorm "—you need every sword you can get. Let them go."

Silence. Then Brakestorm lowers his axe.

"Fine. Get out. If I see you again, I'll kill you."

The traitors back away, then flee into the darkness.

~ mercs_alive -= 2
~ kabenor_trust -= 1
Captain Brakestorm shakes his head. "Should have killed them. But you saved lives today. I'll remember that."

-> continue_after_treason

=== double_cross ===
You step toward the traitors, hands raised.

"I'm with you. Let's end this."

They grin. "Smart man."

You walk toward them—then spin, driving your blade into the nearest one's chest.

"Never trust a stranger," you whisper.

The battle erupts. The traitors are caught off guard, and the loyalists make short work of them.

~ mercs_alive -= 3
~ kabenor_trust += 1
Captain Brakestorm nods at you. "Devious. I like it."

-> continue_after_treason

=== treason_captain_dead ===
Without the captain, the mercenaries are nervous. A few of them gather in a corner, speaking in whispers.

"The captain's dead. Why are we still here?"

"Kabenor's paying us. That's why."

"Kabenor's paying him," one says, jerking a thumb at Kabenor. "We're just meat."

"We should leave."

"And do what? Go back empty-handed?"

"Better empty-handed than dead."

* [Agree - leave with the traitors]
    -> leave_with_traitors

* [Refuse - continue the mission]
    -> continue_alone

=== leave_with_traitors ===
You nod. "You're right. Let's get out of here."

The remaining mercs—those who aren't too wounded to walk—follow you back toward the surface.

But the catacombs have other plans.

-> ghoul_attack

=== continue_alone ===
"No. We finish this."

The others stare at you. "You're insane."

"Maybe. But I'm not leaving without seeing what's down there."

Kabenor smiles. "Brave. Or foolish. Either way, follow me."

The remaining mercs exchange glances, then follow.

-> continue_after_treason

// ============================================
// GHOUL ATTACK (When leaving)
// ============================================

=== ghoul_attack ===
// THE HUNGRY DARK
You're halfway back to the surface when the ghouls attack.

They come from the walls, the ceiling, the floor—pale, gaunt creatures with too-long limbs and too-wide mouths.

The mercs scream. Weapons flash. Blood sprays.

You fight. You kill. But there are too many.

One by one, your companions fall. Vex is dragged into the darkness, screaming. The others die fighting.

You run. There's nothing else to do.

You run deeper into the catacombs, away from the ghouls, away from the surface. You run until your lungs burn and your legs give out.

When you finally stop, you're in a chamber you don't recognize. And you're not alone.

-> meet_kabenor_wounded

// ============================================
// CONTINUE AFTER TREASON (Captain alive path)
// ============================================

=== continue_after_treason ===
// DESCENT TO THE DEEPEST CHAMBER
The party continues downward. The tunnels grow older, more ornate. The carvings on the walls depict things that hurt to look at.

Kabenor leads without hesitation, as if he knows exactly where he's going.

{captain_alive:
    Captain Brakestorm walks beside you.

    "That man knows more than he's telling," he says quietly. "Stay sharp."
- else:
    You walk in silence. The captain's absence is a weight on everyone's shoulders.
}

Finally, you reach a massive door—black stone, covered in symbols that glow faintly.

Kabenor places his hand on it. The symbols flare. The door opens.

"Beyond lies the deepest chamber," he says. "Do not touch the gold. Do not approach the throne until I say. And whatever you see... do not interfere."

-> final_chamber

// ============================================
// MEETING KABENOR (Ghoul path)
// ============================================

=== meet_kabenor_wounded ===
// THE HIDDEN CHAMBER
You stumble into a chamber lit by flickering torches. Kabenor stands at the far end, surrounded by a handful of wounded mercenaries.

They look at you with hollow eyes.

"You survived," Kabenor says. "Interesting."

"How... how are you here?"

"I know these tunnels better than anyone." He gestures. "You're wounded. Rest. We'll speak soon."

You have no choice but to comply.

-> final_chamber

// ============================================
// FINAL CHAMBER
// ============================================

=== final_chamber ===
// THE THRONE OF THE LICH
The chamber is vast—a cathedral of death. Gold coins litter the floor like fallen leaves. Jewels gleam in the torchlight. Ancient treasures beyond imagining lie piled against the walls.

But your eyes are drawn to the center.

A throne of black stone sits on a raised dais. In it sits a skeleton wearing a crown of tarnished gold. A pool of golden liquid surrounds the throne—shimmering, beautiful, wrong.

Only a thin marble path leads through the golden liquid to the throne.

Kabenor raises a hand. "Do not touch the gold. Do not stray from the path. And do not approach the throne."

{captain_alive:
    -> final_no_touch
- else:
    -> final_mercenary_greed
}

=== final_no_touch ===
Captain Brakestorm nods. "You heard him. Nobody touches anything."

The party stays back. Kabenor walks the marble path alone, approaching the throne.

He stops before it. Reaches out. Touches the skeleton's crown.

Then he begins to chant.

-> kabenor_transforms

=== final_mercenary_greed ===
One of the surviving mercenaries stares at the gold with naked greed.

"Just one coin," he mutters. "One coin, and I can retire."

"Don't," you say.

But he doesn't listen.

* {cunning >= 6} [Tackle him - stop him physically]
    -> final_stop_mercenary

* {player_class == "wizard"} [Use magic to freeze him in place]
    -> final_magic_stop

* {player_class == "bard"} [Convince him it's cursed]
    -> final_convince

* [Let him do it]
    -> final_mercenary_touches

=== final_stop_mercenary ===
You lunge, tackling the mercenary to the ground before he can touch the gold.

"Are you insane? Look at this place!"

He struggles, then goes limp. "Fine. Fine! Get off me."

~ stopped_merc = true
Kabenor glances back. "Wise."

-> kabenor_transforms

=== final_magic_stop ===
You gesture sharply, and the mercenary freezes mid-step—paralyzed by invisible force.

"Stay," you command. "Or die."

He stays.

~ stopped_merc = true
~ magic -= 2
Kabenor watches with interest. "You have more power than you let on."

-> kabenor_transforms

=== final_convince ===
"Look at it," you say softly. "Does that look like normal gold to you? It's too bright. Too perfect. It's a trap."

The mercenary hesitates. His hand drops.

"You're right. You're right."

~ stopped_merc = true
Kabenor says nothing, but you feel his approval.

-> kabenor_transforms

=== final_mercenary_touches ===
The mercenary kneels and touches a single gold coin.

Instantly, his skin hardens. His eyes widen in horror. His mouth opens to scream—but no sound comes out.

He is solid gold now. A statue of greed.

~ mercs_alive -= 1
Kabenor doesn't even look back. "I warned him."

-> kabenor_transforms

=== kabenor_transforms ===
// THE RITUAL
Kabenor stands before the throne, chanting in a language that predates humanity. The ground shakes. The golden liquid begins to boil.

His flesh begins to tear.

{captain_alive:
    Captain Brakestorm draws his axe. "What's happening? Kabenor! What are you doing?"

    Kabenor ignores him.

    * [Join the captain in demanding answers]
        -> demand_answers

    * [Watch in horror]
        -> watch_ritual

    * {player_class == "wizard"} [Prepare a counterspell]
        -> wizard_counterspell
- else:
    The remaining mercenaries scream and flee into the darkness.

    * [Run after them]
        -> run_away_ending

    * [Stay and watch]
        -> watch_ritual

    * {player_class == "wizard"} [Prepare a counterspell]
        -> wizard_counterspell
}

=== demand_answers ===
"Kabenor! Answer me!"

The client turns. His face is... wrong. Flesh peels away from bone. His eyes burn with green fire.

"You wanted to know what lies in the deepest chamber," he says. "Now you see."

He laughs—a sound like breaking bones—and continues his chant.

-> kabenor_reveals

=== watch_ritual ===
You can't look away.

Kabenor's skin tears away in strips. His muscles blacken. His bones glow with necrotic energy. He is dying and being reborn at the same time.

The skeleton on the throne begins to crumble. The crown lifts into the air, floating toward Kabenor.

"I have waited," he screams, "for CENTURIES!"

-> kabenor_reveals

=== wizard_counterspell ===
You draw upon every shred of arcane knowledge you possess. This is a lich transformation—one of the darkest rituals in existence.

You have seconds to act.

* {magic >= 8} [Attempt to disrupt the ritual]
    -> wizard_disrupt

* {knows_kabenor_secret} [Use your knowledge to redirect the ritual]
    -> wizard_redirect

* [Wait and see what happens]
    -> kabenor_reveals

=== wizard_disrupt ===
You raise your hands and unleash raw arcane force.

The ritual stutters. Kabenor screams as the energy backlashes into him.

But he's too strong. Too prepared.

"You cannot stop this," he snarls. "But you have earned my respect."

The crown settles onto his brow. The transformation completes.

-> kabenor_reveals

=== wizard_redirect ===
You know something Kabenor doesn't: the ritual can be shared.

You whisper words of power, weaving yourself into the incantation. The crown slows in the air—then splits.

Half settles on Kabenor's brow. Half hovers before you.

"NO!" Kabenor screams. "WHAT HAVE YOU DONE?"

But it's too late. You have a choice to make.

-> lich_choice

=== kabenor_reveals ===
// THE NEW LICH
Kabenor rises from the ritual transformed. His flesh is gone—only bone remains, wrapped in robes of shadow. The crown of the lich rests on his skull, and his eyes burn with malevolent green fire.

"I am reborn," he says, and his voice echoes in your mind. "I am eternal. And you..."

He looks at the party.

"You may serve me. Or you may die."

{captain_alive:
    Captain Brakestorm steps forward. "We kill him. Now. While he's still weak."

    * [Fight alongside the captain]
        -> battle_lich

    * [Run - this is unwinnable]
        -> run_away_ending

    * {player_class == "wizard" && knows_kabenor_secret} [Become a lich yourself]
        -> lich_choice

    * [Kneel and serve]
        -> serve_ending
- else:
    You are alone. The captain is dead. The mercenaries are dead or fled.

    * [Fight the lich alone]
        -> battle_lich_alone

    * [Run - this is unwinnable]
        -> run_away_ending

    * {player_class == "wizard" && knows_kabenor_secret} [Become a lich yourself]
        -> lich_choice

    * [Kneel and serve]
        -> serve_ending
}

=== battle_lich ===
"Now!" Captain Brakestorm roars. "Together!"

You and the remaining loyal mercenaries charge the newborn lich. Blades flash. Spells fly.

Kabenor is powerful—but he's newly transformed, still adjusting to his power.

{combat_skill >= 6 || magic >= 6:
    You drive your weapon into the lich's skull. Captain Brakestorm cleaves through his ribs. The mercenaries stab and slash.

    Kabenor screams—a sound that shatters stone—and bursts into green flame.

    When the fire clears, only ash remains.

    The crown clatters to the floor.

    Captain Brakestorm kicks it into the golden liquid, where it sinks and dissolves.

    "Well," he says, breathing hard. "That was something."

    -> victory_ending
- else:
    You fight bravely. But Kabenor is too strong.

    One by one, your companions fall. Captain Brakestorm dies fighting, his axe buried in the lich's shoulder.

    You're the last one standing.

    "You fought well," Kabenor says. "But not well enough."

    He raises a hand. Dark energy gathers.

    -> death_ending
}

=== battle_lich_alone ===
You charge the lich alone. It's suicide—but what choice do you have?

Kabenor laughs. "Alone? Pathetic."

He raises a hand. Dark energy slams into you, lifting you off your feet and throwing you against the wall.

You feel your ribs crack. Your vision blurs.

"Perhaps I'll keep you as a pet," Kabenor muses. "An undead servant. That would be amusing."

* {combat_skill >= 8 || magic >= 8} [Rally - one last attack]
    -> battle_lich_desperate

* [Accept your fate]
    -> death_ending

=== battle_lich_desperate ===
You force yourself to your feet. Blood drips from a dozen wounds. Your vision is failing.

But you have one last attack in you.

You charge, screaming, and drive your weapon into the lich's chest.

Kabenor stares down at you, almost... impressed.

"You have spirit. I'll give you that."

He flicks his wrist. Your body breaks.

-> death_ending

// ============================================
// LICH CHOICE (Wizard path)
// ============================================

=== lich_choice ===
// THE CROWN
The half-crown hovers before you. It pulses with dark power—the accumulated knowledge and malice of centuries.

Kabenor is still transforming, still screaming, still vulnerable. But you don't have much time.

The crown offers you everything: power over death, immortality, the ability to reshape the world.

But at what cost?

* [Take the crown - become a lich]
    -> become_lich

* [Refuse - destroy the crown]
    -> refuse_crown

* [Offer the crown to someone else]
    -> offer_crown

=== become_lich ===
You reach out and take the crown.

Agony. Bliss. Death. Rebirth.

Your flesh tears. Your bones blacken. Your soul... changes.

When it's over, you stand beside Kabenor—two liches in a world that can't contain one.

"Welcome friend," Kabenor says.

He gestures to the fallen mercenaries, the fleeing survivors.

"Shall we conquer this world together?"

* [Yes - together]
    -> lich_together_ending

* [No - this world is mine alone]
    -> lich_alone_ending

=== refuse_crown ===
You thrust your hand forward, not to take the crown, but to destroy it.

Arcane energy erupts from your palm. The crown shatters.

Kabenor screams—not in pain, but in loss. "You... you've ruined everything!"

But the damage is done. His transformation fails. His body crumbles to dust, leaving only a skeletal figure in robes, power drained.

Captain Brakestorm finishes the job with his axe.

"You saved us," he says. "Thank you."

-> victory_ending

=== offer_crown ===
You catch the crown—then turn to Captain Brakestorm.

"Catch."

You toss it to him.

He catches it reflexively. The crown touches his brow.

He screams.

The transformation is fast—brutal. Captain Brakestorm dies and is reborn in seconds. When it's over, a new lich stands before you.

"You..." he says, his voice echoing. "Why?"

"You're the leader," you reply. "Now lead."

Kabenor screams in fury. "You CANNOT take what is MINE!"

The two liches battle—an apocalyptic clash of necrotic power. You flee while they fight.

-> survive_ending

// ============================================
// ENDINGS — FULL EPILOGUES
// ============================================

=== run_away_ending ===
// EPILOGUE: THE COWARD'S SURVIVAL
You run.

You run until your legs give out and your lungs burn. You run until the screams of your companions fade into silence behind you. You run until the catacombs spit you out into a cold, indifferent dawn.

You emerge alone. The sun blinds you. The birdsong sounds alien, obscene—like laughter at a funeral.

{captain_alive:
    Captain Brakestorm's last words follow you up the tunnel. Not a curse. A command.

    "Finish the job."

    You didn't. You left him to die in the dark, fighting a thing wearing a dead man's face. You left him with his axe in his hands and no one at his back.

    You will hear that voice for the rest of your life.
- else:
    There was no one left to hear you leave. The captain was already dead. The mercenaries were already dead. You were already dead in every way that mattered.

    The tunnel behind you was silent. That was the worst part.
}

You go home. You tell yourself you had no choice. You tell yourself anyone would have done the same.

You almost believe it.

For a year, nothing happens. You find work. You drink. You sleep. You try to forget the smell of the catacombs, the sound of chanting, the way Kabenor's flesh peeled away from his bones like wet paper.

Then the rumours start.

A village goes silent. A graveyard empties in a single night. A fog rolls out of the mountains that walks, and talks, and calls people by name.

At first, the rumours are just rumours. Then they become news. Then they become war.

Kabenor does not conquer quickly. He does not need to. The dead do not tire. The dead do not doubt. The dead do not run.

Within three years, the northern provinces are his. Within ten, half the world kneels to a crown of tarnished gold.

You live through all of it. You grow old. You marry, perhaps, or you don't. You find honest work, quiet work—work that keeps your hands busy and your mind empty.

It doesn't work.

Every night, you hear it. Not the lich's laughter, as you feared. Something worse.

You hear Captain Brakestorm's voice, patient and low, saying: "Finish the job."

You wake in a cold bed in a free country that is free only because the lich has not yet bothered to look this way.

You die in that bed, many years later. Peacefully, if such a word can be used.

No one at your funeral knows what you did. No one knows what you didn't do.

The world burns on without you.

THE END (Coward's Survival)

-> END

=== victory_ending ===
// EPILOGUE: THE WORLD ENDURES
Kabenor falls.

The crown shatters into a thousand pieces of meaningless gold. The lich's green fire gutters out, and the catacombs fall still—truly still, for the first time in centuries. The dead return to their alcoves. The whispers fade. The throne crumbles.

You climb out of the dark and into a world that will never know how close it came to ending.

{captain_alive:
    Captain Brakestorm climbs out beside you.

    He is wounded in a dozen places. He is missing more fingers than he started with. He is alive.

    He doesn't say anything for a long time. When he finally does, it isn't *thank you*.

    "Drink with me."

    You do. In a tavern two days' ride from the catacombs, you drink until the sun comes up. Neither of you speaks of the lich, or the crown, or the men you left behind. You speak of nothing at all.

    It is the best conversation you have ever had.

    He offers you a place in his company. You take it. You fight beside him for years—through border skirmishes, through monster hunts, through a dozen small wars that history will not remember.

    You are there when he dies, twelve years later, of a fever he caught in a swamp. His last words are not profound. They are, in fact, an insult directed at a priest. You laugh, because he wanted you to.

    You carry his axe for the rest of your life. You hang it above your door in a small house in a small town, and when travellers ask about it, you tell them it belonged to the best man you ever knew.
- else:
    You climb out alone.

    There is no one to drink with. No one to share the silence with. The men who followed you into the dark are still in the dark, and they will be there forever, because no one is coming back for them.

    You tell the story once—to a magistrate, to a priest, to someone who needs to know—and then you never tell it again. There are no songs about you. There is no company to join.

    There is only the world, continuing. The sun rises. The crops grow. Children are born who will never know a lich existed.

    You find a small house on the edge of a small town. You keep bees. You learn to whittle. You become, slowly, a person who has not killed anyone in a long time.

    It is enough. It has to be enough.

    When you die, you leave behind nothing but a beehive and a wooden soldier you carved for a child who never visited. It is, in its way, a monument.
}

The world knows peace for a time. And when darkness comes again—as it always does—someone else will be there to meet it.

You made sure of that.

THE END (Victory)

-> END

=== death_ending ===
// EPILOGUE: ASHES AND SILENCE
You die.

It is not quick. The lich is not merciful.

Your body breaks in stages. First the ribs. Then the arms. Then the spine. Your screams are the last human sound in the catacombs for a very long time.

Then Kabenor reaches into what is left of you and takes what he needs.

You do not stop existing. That would be a kindness. Instead, you are *remade*—a thing of cold bone and colder obedience, standing in the darkness of the throne room, watching through dead eyes as the lich takes the crown and walks up into the world.

You serve.

You serve for a century. You serve for ten. You stand at his side while he conquers the north, then the south, then the seas. You kill for him—farmers, soldiers, children. You kill without hesitation, because you are no longer a thing that can hesitate.

You remember, at first.

You remember the rain on the archway. The first torch-lit chamber. Mira's scarred arms. Dorn's silence. The way Captain Brakestorm never looked at the same shadow twice.

You remember saying *yes* to this job.

After a hundred years, you stop remembering. After two hundred, you stop wanting to. After three hundred, you are no longer sure there was ever anyone named you at all.

You are only the servant. You are only the sword.

And the world burns on, and the lich rules on, and somewhere very far away, in a world you can no longer imagine, a young sellsword signs a contract to escort a hooded man into a catacomb.

THE END (Death)

-> END

=== serve_ending ===
// EPILOGUE: THE SERVANT
You kneel.

{captain_alive:
    Captain Brakestorm roars.

    He has lost men to this. He has lost fingers to this. He has lost sleep to this, and now he is watching you give away the thing he was fighting for, and he will not stand for it.

    "GET UP," he bellows. "GET UP AND FIGHT."

    You don't.

    He turns on Kabenor instead—axe raised, charging the newborn lich with all the fury a man can hold. It is a magnificent charge. It is the charge of a man who has decided he is going to die today and has chosen to make it count.

    Kabenor does not even raise his hand.

    The lich simply *looks* at him, and Captain Brakestorm stops. Mid-stride. Mid-roar. His axe falls from his fingers and clatters on the marble. His face goes slack.

    "You were a good soldier," Kabenor says, almost gently. "You will make a better servant."

    He does not kill the captain. He does something worse.

    He *unspools* him. Right there, in front of you. Years and years of memory, of love, of fury—pulled out like thread from a spool and scattered on the golden floor. Captain Brakestorm stands where he is, eyes open, empty.

    Then he walks over to you—this hollow thing wearing your captain's face—and stands beside you, and waits.

    "Two servants," Kabenor says, sounding pleased. "How generous of you."

    You do not cry. You have forgotten how.
- else:
    There is no one left to object. The captain is dead. The mercenaries are dead or fled. You kneel into silence, and Kabenor accepts it.

    "Good," he says. "You understand."

    You do not understand. You only obey.
}

You serve.

At first, you serve well. You are still yourself, mostly. You still think. You still remember. You still flinch, when you are sent to do things that a person should flinch at.

You try not to think about the things you have agreed to. It is easier, you find, to simply not think about them.

The lich is not cruel to you. That is the worst part. He is *kind*. He gives you power—real power, the kind you once dreamed of when you were nothing but a sellsword with a cheap sword. He gives you a place at his side. He gives you a name that is spoken in terror from one end of the world to the other.

He gives you everything you ever wanted.

In return, you give him the world.

Together, you break the last free kingdoms. Together, you put out the last fires of resistance. Together, you watch the dead walk in cities where children used to play.

And every night, you tell yourself you are still you. And every morning, you are less sure.

{captain_alive:
    The captain stands beside you through all of it. His eyes are still empty. He still does not speak. But sometimes, when the lich is not watching, you catch him looking at you—really looking—and you wonder if somewhere deep inside that hollow shell, a man is still screaming.

    You hope not. For his sake.

    You hope so. For yours.
- else:
    You are alone.

    That is the only difference. It is enough of a difference.
}

You serve for a very long time.

And one day, you realize you can no longer remember why you ever wanted anything else.

THE END (Servant)

-> END

=== lich_together_ending ===
// EPILOGUE: THE DYING WORLD
You rise from the ritual.

Agony. Bliss. Death. Rebirth. And then—*clarity*. The clarity of a thing that has stopped being afraid.

You stand beside Kabenor in the throne room. Two crowns now, not one. Two liches, in a world that can barely contain one.

"Shall we?" he says.

You do.

The conquest is not a war. It is a *process*. The living are not built to fight things that cannot die. Their armies break. Their walls crack. Their gods are silent. Their kings beg.

You do not listen to kings.

The first kingdom falls in a week. The second in a month. The third, you don't bother to count.

By the end of the first year, you rule the north. By the third, the south. By the tenth, everything under the sun that is not the sea.

And then the real work begins.

You rule *well*. That is the terrible part. You rule well. The roads are safe. The harvests are organized. There is no more war, because the dead do not wage war. There is no more famine, because the dead do not eat. There is no more crime, because the dead do not steal.

There is no more *life*, either. Not the kind that matters.

The living become livestock. They farm, and they build, and they breed, and they die, and their corpses rise to labour in the fields. They are not treated cruelly. They are simply no longer the point.

You rule for a century. You rule for ten. The world grows quieter. The great cities are rebuilt in bone and black stone. The forests are cut down for the pyres. The oceans are fished empty.

And one day, standing on a balcony overlooking a city of the dead, you realize you have not spoken to a living person who was not your servant in three hundred years.

You turn to Kabenor beside you.

"There is nothing left," you say.

"Yes," he agrees. "Isn't it wonderful?"

The world dies slowly after that. Not with a bang, but with the long, quiet extinction of everything that isn't already still.

The last human is born, lives, dies, rises. The last animal is hunted for sport and never replaced. The last tree falls.

You rule over a world of silence.

You rule for a thousand years.

You rule for ten thousand.

And then, one day, you turn to Kabenor to speak—and you find that you have forgotten what you wanted to say, and that he has forgotten you were ever there.

You are two thrones in an empty room. There is no one left to rule. There is no one left to be.

It is, you suppose, exactly what you chose.

THE END (The Dying World)

-> END

=== lich_alone_ending ===
// EPILOGUE: THE LONELY THRONE
You betray Kabenor.

He does not see it coming. That is the beauty of it. He trusted you—genuinely trusted you, in the way that one monster can trust another when they have both signed the same terrible contract. He stood beside you while the crown split, and he believed you would stand beside him forever.

You wait until he is at his weakest. It takes years. You are patient in ways you never knew you could be.

When the moment comes, you take his crown. You take his power. You take his soul, which tastes of centuries and hunger and the ruins of a life he never told anyone about.

He does not scream. He laughs, at the end. He laughs and says: *"Of course. Of course you would."*

Then he is gone.

You are the only lich now. The sole ruler of death.

You take the throne of the dead kingdom. You sit in the hall of bones, surrounded by gold and silence, and you understand that you have won.

The conquest is slow, because you are alone, but it is inevitable. The living cannot stop you. Nothing can stop you. Within a century, the whole of the known world answers to your crown.

You rule.

The first hundred years are busy. There are rebellions to crush, kingdoms to absorb, servants to create. You are always moving, always planning, always *doing*.

The second hundred years are quieter. The rebellions have stopped. The kingdoms have been absorbed. Your servants are many.

The third hundred years are silent.

You sit on the throne of bones, surrounded by gold, and you wait.

For what, you cannot say.

You wait for a challenger. None comes. You wait for a rival. None exists. You wait for anything at all to happen, and nothing does.

You begin to talk to yourself. You begin to talk to Kabenor, who is not there—whose soul you consumed, whose laughter you still hear sometimes when the wind moves through the hollow places of your skull.

You begin to argue with him. You lose, sometimes.

A thousand years pass. Ten thousand. The world outside becomes a rumour. The living, in the scattered villages that still exist beyond your reach, tell stories about the Lonely King, who rules the dead and speaks to no one.

You are not a king. You are not a god. You are a thing in a room, waiting for a conversation that will never come.

And one day, sitting on that throne, surrounded by all the gold in the world, you understand the truth of immortality:

It is not a gift. It is not a curse. It is simply *time*, given to a thing that no longer knows what to do with it.

You wait.

THE END (The Lonely Throne)

-> END

=== survive_ending ===
// EPILOGUE: THE SPECTATOR
You leave the two liches to their battle.

Behind you, the catacombs collapse. You feel the ground shake as you run—two immortal powers, clashing in the dark, fighting for the right to rule the world you are fleeing.

You do not stop to see who wins. You do not want to know.

You emerge into sunlight. You are alone.

{captain_alive:
    You emerge alone—but the captain's axe is in your hand, because you took it. You do not know why. You did not mean to. It was simply there, and you were leaving, and your hands closed around it before your mind could object.

    You carry it for the rest of your life.

    It is the only thing you keep from the catacombs. Everything else—the coins, the memories, the names—you leave behind.
- else:
    You emerge alone. That is simply the truth. You carry nothing from the catacombs but yourself, and even that feels like too much.
}

The war between the liches lasts for centuries.

You watch from a distance. You cannot help but watch—the whole world is watching, in the end. Two crowns, two thrones, one world, and no one able to stop them.

The war does not end. It simply *continues*. The dead fight the dead. The living die in the crossfire. Kingdoms rise and fall over the course of a single winter. The sun, some years, does not seem to rise at all.

You find a small village on the edge of the world. You give a false name. You learn to fish. You learn to garden. You learn to live.

You marry, perhaps. You have children, perhaps. It depends on the year, and on who you are by then.

You never speak of the catacombs. You never speak of Kabenor. You never speak of what you saw, or what you did, or what you almost became.

But sometimes—late at night, when the wind is right—you hear the sound of breaking bones.

You hear it and you do not move. You lie in the dark, in a house you built with your own hands, in a village that will never know your name, and you listen to the sound of the world tearing itself apart far away.

And you tell yourself you did the right thing.

You tell yourself that every night for sixty years.

You die in that house. Someone buries you under a tree you planted yourself. The war goes on without you. The world goes on without you. The liches go on without you.

You were never the point.

But you were there. You saw it. And you walked away.

THE END (The Spectator)

-> END