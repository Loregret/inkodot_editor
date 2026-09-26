// The Duel for Lady Elena
// Tactical combat system. Night phase is once-only; duel actions are repeatable.

VAR skill = 0
VAR resolve = 0
VAR elena_love = 0
VAR activities_done = 0
VAR knows_cedrics_secret = false
VAR elena_token = false

VAR alistair_stamina = 0
VAR alistair_max = 0
VAR cedric_stamina = 0
VAR cedric_max = 5
VAR cedric_stance = ""
VAR last_player_move = ""
VAR round = 1
VAR used_second_wind = false

-> start

== start ==
# The Duel for Lady Elena

Rain traces lines down the window glass. You have not slept.

You are Sir Alistair — a knight with a good name and an empty purse. You have loved Elena Ravenswood since the autumn, when she laughed at you for falling from your horse into a hedge. You had mud in your hair and a cut on your cheek. She said your name — Alistair — as though it were a word worth saying.

Tomorrow at dawn, you fight Lord Cedric of Ashford for her hand. He is rich. He is cruel. He is favored by her father.

Last night, a servant brought you a note in Elena's hand. Three words.

"Do not lose."

You have time for two things before dawn. Choose carefully.

-> night_choices

== night_choices ==
{
- activities_done > 1:
    -> night_end
}
The candle gutters. What do you do with the remaining hour?

* [Sharpen your blade in the training yard] -> practice
* [Try to write to Elena] -> letter
* [Walk in the rain and think] -> walk
* [Drink at the tavern] -> drink

== practice ==
~ skill = skill + 2
~ activities_done = activities_done + 1
The training yard is slick with rain. You strip off your coat and work until your arms burn. Old Master Reynard — dead these five years — used to say: "The blade is honest. It tells the truth about a man." You never understood him until tonight. Every stroke you make is a confession. You are afraid. You are angry. You are in love.

You practice until the fear is smaller than the love.

-> night_choices

== letter ==
~ elena_love = elena_love + 2
~ activities_done = activities_done + 1
You sit at the desk. You take up the quill. You write:

"My dearest Elena —"

You stop. You crumple the page. You try again.

"Elena —"

You stop. You crumple the page.

On the third attempt, you write only this:

"I will not lose. Not because I am the better swordsman. Because I am the man who loves you."

You seal it. You send it with a servant. Whatever happens tomorrow, she will know.

-> night_choices

== walk ==
~ elena_love = elena_love + 1
~ resolve = resolve + 1
~ elena_token = true
~ activities_done = activities_done + 1
You walk in the garden, where the rain is soft and the hedges are dark. Her window is lit.

You should not look. You look.

She is there. She sees you. She opens the window a crack — just a crack — and puts a finger to her lips.

"Alistair," she whispers. "You should be sleeping."

"I cannot."

"Neither can I." She glances behind her. "My father has locked the door. But I wanted — I wanted to give you something."

She drops something small into the wet grass. A ribbon. Blue, the color of her eyes.

"Come back to me," she says. "Not as a victor. As yourself."

She closes the window. You pick up the ribbon and tie it around your wrist.

-> night_choices

== drink ==
~ knows_cedrics_secret = true
~ skill = skill - 1
~ resolve = resolve - 1
~ activities_done = activities_done + 1
The tavern is loud and low. You take a corner table and order wine you cannot afford.

Cedric's men are at the bar. They do not see you. They are drunk, and they are talking.

"The old man's debts," one says. "He'll be in the Fleet by Michaelmas if this marriage doesn't happen."

"The Ravenswood gold will save him," says another. "And Cedric will be Lord Ravenswood's heir. Poor bastard."

"Poor bastard nothing. He's marrying the girl. He'll have her and the money."

They laugh. You do not.

You drink until the candle burns low. The wine is sour. The truth is worse.

-> night_choices

== night_end ==
Dawn comes grey and wet.

The dueling ground is a field behind the manor, mud churned by boots and hooves. A small crowd has gathered. Lord Ravenswood stands on the balcony, grim. Elena is beside him, pale as parchment. She does not look at you. She looks at the sky.

Cedric waits in the center of the field. His blade is drawn. He smiles when he sees you.

"Alistair," he calls. "You look tired. Did you sleep badly? I slept very well. I dreamed of my wedding night."

+ [Answer with steel in your voice] -> duel_taunt_steel
+ [Answer with a joke] -> duel_taunt_joke
+ [Say nothing. Let your eyes speak.] -> duel_taunt_silent

== duel_taunt_steel ==
~ resolve = resolve + 1
"I have dreamed of nothing but this field, Cedric. And of you on your knees in the mud."

His smile falters. The crowd murmurs. Somewhere behind you, a woman gasps.

-> duel_begin

== duel_taunt_joke ==
~ elena_love = elena_love + 1
"I slept like a baby, Cedric. Woke up every hour and cried."

Someone laughs — a low, surprised laugh. You do not look, but you know it is Elena.

Cedric's smile disappears.

-> duel_begin

== duel_taunt_silent ==
You meet his gaze. You do not speak. You do not blink.

The silence is heavier than any insult. Cedric's smile tightens. He does not like being ignored.

~ resolve = resolve + 1

-> duel_begin

== duel_begin ==
You draw your sword. It is not a fine blade — it is old, and nicked, and it belonged to your father. But it is honest, and it is yours.

Lord Ravenswood raises his hand.

"Begin."

~ alistair_max = 4
{
- skill > 1:
    ~ alistair_max = alistair_max + 1
}
{
- resolve > 1:
    ~ alistair_max = alistair_max + 1
}
~ alistair_stamina = alistair_max
~ cedric_max = 5
~ cedric_stamina = cedric_max
~ round = 1
~ last_player_move = ""
~ used_second_wind = false

Cedric does not wait. He lunges — and the duel begins.

You take his measure. He is strong, and fast, and he fights with the coldness of a man who has nothing left to lose but his pride.

* [Continue] -> duel_round

== duel_round ==
-> cedric_choose_stance

== cedric_choose_stance ==
{
- round == 1:
    ~ cedric_stance = "aggressive"
- last_player_move == "attack":
    {
    - RANDOM(1, 10) <= 6:
        ~ cedric_stance = "guarded"
    - else:
        ~ cedric_stance = "feinting"
    }
- last_player_move == "defend":
    {
    - RANDOM(1, 10) <= 6:
        ~ cedric_stance = "feinting"
    - else:
        ~ cedric_stance = "aggressive"
    }
- last_player_move == "feint":
    {
    - RANDOM(1, 10) <= 6:
        ~ cedric_stance = "aggressive"
    - else:
        ~ cedric_stance = "guarded"
    }
- else:
    ~ cedric_stance = "guarded"
}
-> duel_choice

== duel_choice ==
Round {round}.

Alistair: {alistair_stamina} / {alistair_max} — {condition_word(alistair_stamina)}
Cedric:   {cedric_stamina} / {cedric_max} — {condition_word(cedric_stamina)}

{ cedric_stance:
- "aggressive":
    Cedric lunges forward, blade leading — aggressive, hungry. If you hold your ground, you might catch him overextended.
- "guarded":
    Cedric pulls back, blade high and tight — a wall of steel. He is waiting for you to commit first.
- "feinting":
    Cedric shifts his weight, showing you openings that are not real. He is trying to draw you out.
}

+ [Attack — strike through his intentions] -> player_attack
+ [Defend — wait and counter] -> player_defend
+ [Feint — trick him into committing] -> player_feint

== player_attack ==
~ last_player_move = "attack"
-> resolve_exchange

== player_defend ==
~ last_player_move = "defend"
-> resolve_exchange

== player_feint ==
~ last_player_move = "feint"
-> resolve_exchange

== resolve_exchange ==
{
- last_player_move == "attack":
    {
    - cedric_stance == "feinting":
        -> hit_cedric
    - cedric_stance == "aggressive":
        -> clash
    - else:
        -> hit_alistair
    }
- last_player_move == "defend":
    {
    - cedric_stance == "aggressive":
        -> hit_cedric
    - cedric_stance == "guarded":
        -> standoff
    - else:
        -> hit_alistair
    }
- else:
    {
    - cedric_stance == "guarded":
        -> hit_cedric
    - cedric_stance == "feinting":
        -> standoff
    - else:
        -> hit_alistair
    }
}

== hit_cedric ==
{
- last_player_move == "attack":
    You do not take the bait. You strike through his feint — and your blade finds his ribs.
- last_player_move == "defend":
    He lunges — wild, overeager. You give ground, let him overextend, and drive your point into his thigh.
- else:
    He stands firm behind his guard. You feint low, then strike high, and your blade grazes his cheek.
}
{
- skill > 3:
    ~ cedric_stamina = cedric_stamina - 2
    A critical blow — you feel the edge bite deep.
- else:
    ~ cedric_stamina = cedric_stamina - 1
}
-> check_fight_state

== hit_alistair ==
{
- elena_token and not used_second_wind:
    ~ used_second_wind = true
    His blade comes for you — and you falter. But the ribbon on your wrist catches your eye, blue as her eyes, and something in you steadies. You raise your blade again. The wound is nothing.
- else:
    {
    - resolve > 3:
        ~ resolve = resolve - 1
        You see the blow coming — and by sheer nerve, you turn it aside. It costs you, but you hold.
    - else:
        ~ alistair_stamina = alistair_stamina - 1
        { stopping:
        - He reads you — and his blade lands.
        - He is faster than you thought. A cut opens across your shoulder.
        - You commit too early. He punishes you for it, blade biting into your side.
        - His answer comes swift and cold, and you feel the wet warmth of blood under your sleeve.
        }
    }
}
-> check_fight_state

== standoff ==
Blades meet. Neither of you gives ground. For a long breath, the fight is still.
-> check_fight_state

== clash ==
~ alistair_stamina = alistair_stamina - 1
~ cedric_stamina = cedric_stamina - 1
You both commit — and both draw blood. You stagger back, and he staggers back, and for a moment you are mirrors of each other.
-> check_fight_state

== check_fight_state ==
{
- cedric_stamina < 1:
    -> aftermath_win
- alistair_stamina < 1:
    -> aftermath_lose
- round > 10:
    -> duel_timeout
}
~ round = round + 1
-> cedric_choose_stance

== duel_timeout ==
The fight has gone on too long. Both of you are bleeding, exhausted, barely standing.

Lord Ravenswood raises his hand.

"Enough."

You lower your blades. Neither of you has won — and neither of you has lost. But the crowd has seen what you are made of.

-> aftermath_draw

== aftermath_win ==
Cedric stumbles. His sword arm shakes. He sinks to one knee in the mud.

You could kill him. The crowd expects it. Lord Ravenswood leans forward.

Instead, you lower your blade.

"Enough," you say. "You have lost. Go home."

Cedric stares at you. For a moment, something flickers in his eyes — not gratitude. Shame. Then he spits in the mud and walks away without a word.

You turn to the balcony. Elena is already running down the steps, her dress dragging in the wet grass. She reaches you and takes your face in her hands.

"You idiot," she says, laughing and crying at once. "You absolute idiot."

You kiss her in the rain, with the crowd watching, and you do not care.

{
- elena_love > 1:
    Later, in the quiet of the evening, she will tell you she loved you from the moment you fell into the hedge. She will tell you she wrote the note before her father announced the duel. She will tell you she would have run away with you if you had lost.
- else:
    Later, in the quiet of the evening, she will be kind, and gentle, and distant. She will grow to love you — she does — but it will take time, and patience, and a thousand small kindnesses.
}

-> END

== aftermath_lose ==
You fall.

The mud is cold. The sky is grey. Cedric stands over you, and his blade is at your throat.

"Stay down," he says. "Or I will finish it."

You stay down.

He turns away. The crowd is silent. Lord Ravenswood declares him the winner. Cedric does not look happy. He looks tired. He looks at Elena.

She is not looking at him. She is looking at you.

{
- elena_love > 1:
    That night, she comes to you in the infirmary. She should not be there. She does not care.
    "I will not marry him," she says. "I will not."
    You try to sit up. She pushes you back down.
    "Rest," she says. "We will find a way."
- else:
    That night, you lie alone in the infirmary. The rain has stopped. The moon is cold.
    You do not see her again for many months. By then, she is Lady Cedric, and you are a ghost in her past.
}

-> END

== aftermath_draw ==
You both stand there, breathing hard, blades lowered. Neither of you has won. Neither of you has lost.

Lord Ravenswood stands.

"Enough," he says. "Neither of you has won by right of arms."

Elena steps forward. She looks at you. She looks at Cedric. She looks at her father.

"I will not be a prize," she says. "I will not be won. I will choose."

{
- elena_love > 2:
    She walks to you. She takes your hand in front of the whole crowd.
    "I choose you," she says. "Not because you fought. Because you are kind. Because you are honest. Because you are the man I love."
    She helps you limp away. You do not look back.
- else:
    She looks at you both with sorrow. Then she turns and walks toward the gate.
    "I choose neither," she says. "I choose myself."
    She does not look back. You watch her go, and you do not know if you will ever see her again.
}

-> END

// ---------------------------------------------------------------
// Helper function for describing stamina in words
// ---------------------------------------------------------------

=== function condition_word(s) ===
{
- s > 4:
    ~ return "fresh"
- s > 3:
    ~ return "steady"
- s > 2:
    ~ return "wounded"
- s > 1:
    ~ return "bleeding"
- s > 0:
    ~ return "reeling"
- else:
    ~ return "down"
}