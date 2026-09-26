VAR found_poison = false
VAR found_letter = false
VAR found_watch = false
VAR found_receipt = false
VAR spoke_to_gable = false
VAR spoke_to_eleanor = false
VAR spoke_to_julian = false
VAR spoke_to_silas = false

-> start

=== start ===
The rain lashes against the carriage windows in a torrential Surrey downpour. The wrought-iron gates of Blackwood Manor loom through the gloom, a jagged silhouette against the bruised evening sky. 

Inspector Reed of the local constabulary stands beneath the portico, his bowler hat pulled low, a brolly clutched in his white-knuckled grip.

* [Step out and greet Reed] You descend from the carriage, ignoring the mud, and approach the Inspector. "Evening, Reed. Give me the particulars."
    Reed tips his hat, his face pale. "Inspector Vance. Thank heavens you have arrived from London. It is Lord Blackwood. He is dead in his study. The door was bolted from the inside. A locked-room mystery, sir."
    ** [Demand entry] "Lead the way, Reed. Let us examine the scene."
        -> study_hub
-> DONE

=== study_hub ===
The study is a cavernous, wood-panelled room, heavy with the scent of stale tobacco, old leather, and the faint, sickly-sweet aroma of bitter almonds. 

{not found_poison:
    Lord Blackwood lies slumped over the massive mahogany desk. A half-empty glass of claret rests near his cold, stiff hand.
}
{found_poison:
    The corpse has been examined. The blue tint to the lips and the bitter almond scent confirm cyanide poisoning via the claret.
}

{not found_letter:
    The desk is littered with scattered papers and an overturned inkwell.
}
{found_letter:
    The desk has been searched. A torn, crumpled letter regarding debts has been secured.
}

{not found_watch:
    The heavy oak sash window stands slightly ajar, letting in the draught. The carpet near the sill is disturbed.
}
{found_watch:
    The window has been inspected. A shattered silver pocket watch, frozen at 11:15 PM, was found in the mud.
}

{not found_receipt:
    The marble fireplace contains the smouldering remains of a recent fire.
}
{found_receipt:
    The fireplace has been sifted through. A half-burnt receipt from a Guildford chemist for 'Prussic Acid' has been recovered.
}

{found_poison and found_letter and found_watch and found_receipt:
    The physical evidence in the room has been thoroughly exhausted. It is time to interview the household.
    * [Proceed to the hallway] You turn on your heel and exit the stifling study.
        -> hallway
}

{not found_poison:
    * [Examine the body] You kneel beside the corpse, leaning in close to inspect the face and the glass.
        ~ found_poison = true
        -> study_hub
}

{not found_letter:
    * [Search the desk] You move to the mahogany desk and carefully sift through the scattered papers.
        ~ found_letter = true
        -> study_hub
}

{not found_watch:
    * [Inspect the window] You cross the room to the heavy oak window, examining the disturbed carpet and the muddy sill.
        ~ found_watch = true
        -> study_hub
}

{not found_receipt:
    * [Sift the fireplace] You kneel before the marble fireplace, using a poker to gently turn over the smouldering ashes.
        ~ found_receipt = true
        -> study_hub
}
-> DONE

=== hallway ===
The main hallway is dimly lit by flickering gaslamps. The grandfather clock ticks loudly in the draughty corridor. 

{spoke_to_eleanor and spoke_to_julian and spoke_to_silas and spoke_to_gable:
    Every member of the household has been interviewed. The pieces of the puzzle are laid bare. It is time to make an accusation.
    * [Return to the parlour] You stride back into the parlour to confront the suspects.
        -> accusation_hub
}

{not spoke_to_gable:
    * [Visit the Kitchen] You head towards the swinging baize doors to speak with the cook, Mrs Gable.
        -> kitchen
}

{not spoke_to_eleanor:
    * [Visit the Parlour] You walk down the east wing to interview Lady Eleanor, the widow.
        -> parlour
}

{not spoke_to_julian:
    * [Visit the Billiard Room] You make your way to the west wing to find Julian, the nephew.
        -> billiard_room
}

{not spoke_to_silas:
    * [Visit the Servants' Hall] You descend the narrow stairs to the basement to question Silas, the butler.
        -> servants_hall
}
-> DONE

=== kitchen ===
The kitchen is swelteringly hot, the Aga range radiating intense warmth. Mrs Gable, a stout woman in a flour-dusted apron, is aggressively scrubbing a copper pot.

{not spoke_to_gable:
    * [Announce presence] You clear your throat loudly. "Mrs Gable. I am Inspector Vance. I require your account of the evening."
        Mrs Gable startles, dropping the scouring pad. "Oh! Inspector. It was a dreadful evening. I was in here preparing the morning dough from ten o'clock onwards. Never left the range."
        ** [Ask about the pantry] "Did anyone else enter the kitchen or the pantry this evening?"
            Mrs Gable nods vigorously. "Just her Ladyship. Came in around a quarter to eleven. Highly unusual, she was. Wore thick leather riding gloves, she did, and took a decanter of claret from the pantry herself. Said his Lordship required a fresh pour."
            ~ spoke_to_gable = true
            -> hallway
        ** [Conclude interview] "I see. Thank you, Mrs Gable. Do not leave the manor."
            -> hallway
}

{spoke_to_gable:
    * [Conclude interview] "Thank you again, Mrs Gable. Do not leave the manor."
        -> hallway
}
-> DONE

=== parlour ===
The parlour is draped in heavy velvet. Lady Eleanor sits rigidly on a chaise longue, clad in immaculate black mourning silk. Her eyes are red, though currently dry.

{not spoke_to_eleanor:
    * [Introduce myself] You stand before her, keeping your tone gentle but firm. "Lady Blackwood. My deepest condolences. Pray, tell me of your movements this evening."
        Eleanor dabs her eyes with a lace handkerchief. "I was in my room, Inspector. Reading. I heard nothing until Silas raised the alarm at midnight. My world is entirely shattered."
        ~ spoke_to_eleanor = true
        -> parlour
}

{spoke_to_eleanor and found_letter:
    * [Confront about the letter] You produce the crumpled note from your coat pocket and hold it up. "A rather threatening letter was on his desk. 'Cut you off entirely if you do not pay the debts.' Was this regarding your nephew's gambling?"
        Eleanor pales, her composure slipping. "I... yes. Julian has been wagering heavily at the clubs. My husband was furious. He intended to change his will and leave the estate to a medical charity. But I swear upon my life, I did not kill him for the money!"
        -> parlour
}

{spoke_to_eleanor and found_poison and spoke_to_gable:
    * [Confront about the poison] You step closer, your voice dropping to a harsh whisper. "You claim you were reading. Yet Mrs Gable saw you in the pantry at 10:45 PM, wearing leather gloves, handling the claret decanter. Cyanide was in that glass, Lady Blackwood."
        Eleanor freezes. The colour drains completely from her face. She opens her mouth, but no sound emerges. The trap has snapped shut.
        -> parlour_final
}

{spoke_to_eleanor:
    * [Conclude interview] "I have no further questions at this moment. Remain here."
        -> hallway
}
-> DONE

=== parlour_final ===
Eleanor's facade shatters entirely. She bursts into hysterical, ugly tears, burying her face in her hands. 

"He was going to leave me with nothing!" she wails, her voice echoing off the velvet walls. "I built this life, I managed this estate for thirty years! I had to secure my future! I wore the gloves so the poison vial would not taint my skin!"

* [Call for the Constable] You turn to the door and raise your voice. "Constable Reed! Bring the irons!"
    Reed steps into the room, his handcuffs clicking in the quiet parlour as he takes the weeping woman into custody.
    ** [Reflect on the case] You look out the mullioned window at the driving rain. Lord Blackwood's murder is solved.
        -> ending_success
-> DONE

=== billiard_room ===
The billiard room is vast, the green baize of the table stark under the gaslight. Julian Blackwood is pacing the length of the room, sweating profusely and chewing his fingernails.

{not spoke_to_julian:
    * [Demand an alibi] You block his path, forcing him to stop. "Mr Blackwood. Where were you between ten and midnight?"
        Julian stammers, his eyes darting around the room. "I was in here! Playing a solitary game of billiards to clear my head. I did not leave the table, I swear it!"
        ~ spoke_to_julian = true
        -> billiard_room
}

{spoke_to_julian and found_watch:
    * [Present the watch] You pull the shattered silver pocket watch from your waistcoat pocket. "This was found by the study window. The hands are frozen at 11:15 PM. The billiard room is on the opposite side of the manor. Explain this."
        Julian stares at the watch, his knees buckling slightly. He sinks into a leather armchair. "I... I went to the study to plead my case! I arrived at 11:15. I saw him slumped over the desk, dead. I panicked and ran away, dropping my watch in the mud. I did not kill him, Uncle Arthur was already dead!"
        -> billiard_room
}

{spoke_to_julian and found_receipt:
    * [Present the receipt] You produce the half-burnt chemist's receipt. "Prussic Acid. Purchased in Guildford three days ago. The handwriting is yours, Julian."
        Julian bursts into tears. "I bought it! I bought it to scare him! I was going to put a few drops in his tea to make him violently ill, to frighten him into changing the will back! But I lost my nerve! I threw the receipt in the study fire and ran away!"
        -> billiard_room
}

{spoke_to_julian and not (found_watch and found_receipt):
    * [Conclude interview] "See that you do not leave the manor."
        -> hallway
}

{spoke_to_julian and found_watch and found_receipt:
    * [Conclude interview] You have the full truth from him. He is a fool, but not a murderer. "Wait here for the Constable."
        -> hallway
}
-> DONE

=== servants_hall ===
The servants' hall is austere and spotless. Silas, the butler, stands perfectly straight beside the polishing station, his face an impassive, stoic mask.

{not spoke_to_silas:
    * [Ask about the wine] You stand before him, noting his immaculate posture. "Silas. You served his Lordship his nightly drink?"
        "I did, Inspector," Silas states, his voice devoid of emotion. "I carried the tray with the decanter of claret to the study at eleven o'clock precisely. His Lordship was alive and well."
        ~ spoke_to_silas = true
        -> servants_hall
}

{spoke_to_silas and spoke_to_gable:
    * [Ask about the pantry] "Mrs Gable states Lady Blackwood took the decanter from the pantry at 10:45 PM. Did you observe this?"
        Silas hesitates. His stoicism cracks just a fraction. "I did, Inspector. I was in the corridor. Her Ladyship was wearing leather gloves. I thought it peculiar, but it is not my place to question the mistress of the house."
        -> servants_hall
}

{spoke_to_silas and spoke_to_julian:
    * [Ask about Julian] "Mr Julian claims he visited the study at 11:15 PM. Did you see him?"
        Silas's eyes narrow slightly. "I saw Master Julian creeping down the east corridor at precisely 11:10 PM. He looked highly agitated. I did not see him return, but I heard a commotion from the study shortly thereafter."
        -> servants_hall
}

{spoke_to_silas:
    * [Conclude interview] "Thank you, Silas. That will be all for now."
        -> hallway
}
-> DONE

=== accusation_hub ===
The three suspects are gathered in the main hall. Eleanor stands by the fireplace, Julian shifts nervously by the door, and Silas remains rigidly by the stairs. Inspector Reed stands by, notebook in hand.

The evidence points in several directions, but only one path leads to the truth.

* [Accuse Eleanor] You point a finger directly at the widow. "Lady Blackwood, you are the murderer."
    -> accuse_eleanor
* [Accuse Julian] You turn to the sweating nephew. "Julian, you poisoned your uncle to secure your inheritance."
    -> accuse_julian
* [Accuse Silas] You fix your gaze on the butler. "Silas, you administered the poison when you served the wine."
    -> accuse_silas
-> DONE

=== accuse_eleanor ===
{found_poison and found_letter and spoke_to_gable:
    "You poisoned the claret!" you declare, your voice echoing in the hall. "You knew of Julian's debts and used them as a smokescreen. You wore leather gloves to handle the cyanide in the pantry at 10:45 PM, ensuring no fingerprints tainted the decanter. When Silas carried the tray at eleven, the poison was already in the glass!"
    
    Eleanor's knees give way. She collapses onto the floor, sobbing hysterically. "He was going to leave me penniless! I had to secure my future!"
    
    Reed steps forward, his handcuffs clicking as he takes her into custody. 
    
    * [Close the case] You turn your collar up against the chill. "Take her away, Reed. The case is closed."
        -> ending_success
}

{not found_poison or not found_letter or not spoke_to_gable:
    You point a finger at Eleanor, attempting to lay out the case, but the crucial details are missing. 
    
    Reed looks at you skeptically. "Inspector Vance, with respect, we have no proof of how the poison was administered, nor a clear motive. Lady Blackwood was in her room all evening, as far as we know."
    
    Eleanor smirks faintly, wiping a dry eye. "You have nothing, Inspector. I demand my solicitor."
    
    * [Accept defeat] You lower your hand, realising you missed vital clues in the study and the kitchen.
        -> ending_failure
}
-> DONE

=== accuse_julian ===
{found_watch and found_receipt:
    "You purchased the prussic acid in Guildford!" you shout, holding up the burnt receipt. "You went to the study at 11:15, administered the poison, and dropped your watch in your haste to escape!"
    
    Julian falls to his knees, weeping. "I bought the acid to scare him! I threw it in the fire! I found him dead at 11:15, I swear it!"
    
    Reed shakes his head. "Inspector, the boy is a fool and a gambler, but the timeline does not fit. The wine was poisoned before he arrived. Furthermore, Lady Blackwood was seen handling the decanter."
    
    * [Realise the mistake] You lower the receipt, realising you have accused a coward, not a killer.
        -> ending_failure
}

{not found_watch or not found_receipt:
    You accuse Julian of the murder, but without the watch to place him at the scene, or the receipt to prove he bought the poison, the accusation falls flat.
    
    Julian crosses his arms, his fear turning to indignation. "You have no evidence, Vance. I was playing billiards all night."
    
    Reed clears his throat. "He is right, sir. We cannot hold him on suspicion alone."
    
    * [Accept defeat] You realise you failed to gather the necessary physical evidence.
        -> ending_failure
}
-> DONE

=== accuse_silas ===
"You served the poisoned wine!" you declare, pointing at the butler. "You took the opportunity to murder your master!"

Silas shakes his head calmly, his expression unchanging. "I served the wine, Inspector, but I did not prepare it. The decanter was already poured and sealed by Lady Blackwood in the pantry. I merely carried the tray. My loyalty to Lord Blackwood was absolute in life, and it remains so in death."

Reed frowns, closing his notebook. "Vance, we need more than just him carrying a tray. The kitchen staff confirmed Lady Blackwood tampered with the decanter. You are barking up the wrong tree. The butler did not do it."

Silas returns to his stoic silence. 

* [Accept defeat] You realise you have ignored the crucial testimony regarding the pantry.
    -> ending_failure
-> DONE

=== ending_success ===
The rain begins to ease as the police carriage carries Eleanor away into the Surrey night. Lord Blackwood's murder is solved, his greedy widow brought to justice. The manor stands silent once more, its dark secrets finally laid to rest.

-> END

=== ending_failure ===
The suspects disperse into the shadows of the manor. The real killer smirks from the periphery, their secret safe. Lord Blackwood's murder remains unsolved, a cold case that will haunt the halls of Blackwood Manor for generations.

-> END