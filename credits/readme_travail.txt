=================================================================================
THE TRAVAIL PACK REQUIRES YOU TO HAVE A REGISTERED VERSION OF QUAKE & 64 MB RAM 
=================================================================================

Table of Contents

        I. THE STORY
                A. Once More Unto the Breach

        II. INSTALLING & RUNNING TRAVAIL
                A. Installation
                B. Running Travail
		C. The Soundtrack

        III. THE BASICS OF PLAY
		A. Goal of the Game
		B. Skill
		C. Episodes

        IV. MODIFICATIONS
		A. Firepower
		B. Ammo
		C. Power-ups
		D. Bad Guys
		E. Environmental Hazards and Effects

        V. MULTIPLAYER ACTION 
		A. Cooperative
		B. Deathmatch

        VI. CONTRIBUTORS
		A. Travail Team
		B. Those Who Answered the Call
		C. They Provided Resources
		D. They Also Inspired - but are as yet unmentioned

	VII. LEGAL BOILERPLATE 

	VIII. SPECIAL THANKS

****************
I. THE STORY

A. Once More Unto the Breach

Red dust on your boots mixes with fresh Shambler blood as you bend down to slurp from the huge neck gash and re-hydrate your abused corpus. Moisture outside of flesh is nowhere to be found on this desert domain and the temples you cleared had only wells filled with bones and spider nests.

Travel back...

Chthon � the undying: he almost stopped your heart by sight alone when you grabbed the first rune you ever held. Shub: you couldn't wait to rinse your armour after loosening in panic because she didn't respond to pounds of lead and steel fired in streams that almost turned barrels to butter. Armagon, Nehahra, and Shrak: new places - menacing faces. You traversed lava scorched runic valleys, muddy damp swamps, tech bases, arid temples, floating voids to ancient castles to hideous hybrids of man and alien tech to� to...

Travel...

Looking for good or...

Evil!

Your final place in the multi-verse?

Wiping your chin, you smear the Shambler's corpuscles over your stubble like a smelly sunscreen, not caring about the salty sting from ruptured blisters oozing across your nose and cheeks. It's quiet again and the bodies are heaped. You tread away from the carnage, back to the sun, leaving ephemeral prints on the rippled dunes. You have developed this sixth sense for finding teleports and slipgates and some inner voice tells you that three days of walking east will take you to another portal if exposure doesn't kill you first. It's as if something has marked out your trail... or...

Trial!

Revel in the destruction of Quake.

Three days pass. You don't die. Scarab beetles that come out at night moisten human flesh and taste better then the spleen of vore.

You come to terra-cotta coloured cliffs carved deep by wind and sand, looking like frozen dunes - an impossible scape of static motion. Fingers of sand reach into the dark crevasses of textured stone, as do late evening shadows. Both touch a cluster of grunt bodies face down and scattered amongst some steel crates, unpacked supplies and a strange looking device that you know by intuition is a slipgate device despite never having actually seen one of its type. You axe open some of the crates and find food and water and medkits! You drop to your knees and thank the real or imagined deity that blesses and curses you in all ways. Looking for ammo does not reward your weapons with similar nourishment but you do find something very odd.

A hardcopy memo in a protective pouch: a written document - not electronic - but hardcopy, on synthetic paper. The ultimate security against hackers! It's half written in code but you know enough from your past life as a marine to decrypt one word.

Azoth!

Azoth�

The name is almost familiar. What was it?

Yes. Now you remember.

You had heard rumours of Azoth muttered by grunts stationed in a desecrated church where undead human blood and flesh were packaged and shipped off to...

Where?

Could these dead grunts at your feet now be part of this... this... 

Travesty!

Evil revealed?

The slipgate device hums and chirps softly, it's small overhead light casting a tentative white glow on the ribbed pad of the dimensional insertion grid. Connecting the light to the base are three curved beams that open like arms, beckoning you into embrace. To pull you in, to absorb, to... to...

No avail!

And yet the ferrous whisper of a teleportation field persists. Near� here! You heave your axe at the rock face where the sound seems loudest, and the facade crumbles away to reveal the next way out. The other device is incoming only (information stored) and this whirling hypnotic field, similar yet different to those you�ve already encountered, is an exit. You stare, matching the rhythm of your breathing to your pulse...

...travel, traverse, evil, trail, trial, revel, evil, Azoth, travesty, evil revealed, no avail, evil, evile, my travail...

And step into the vortex...

****************
II. INSTALLING & RUNNING TRAVAIL

A. Installation

Create a new folder in your /quake/ directory and name it 'travail'.
Decompress the 'travail' archive into this new folder. Make sure to maintain any directory structure which exists within the archive. 

B. Running Travail

Start your favorite quake engine port with '-game x' where x is the name of the new folder (probably 'travail'). An unmodified version of Quake (winquake, etc) will probably not like certain areas of this mission, so some modified engine will be required. 

NOTA BENE: Due to the large number of textures used in this mod, NO MATTER WHAT THE ENGINE, remember to save and reload each time you return to the rusted start base. This will circumvent the possibility of a 'too many textures' crash as you proceed.

Travail target engine (highly recommended):

FitzQuake http://www.celephais.net/fitzquake/
- Many thanks to John (metlslime) Fitzgibbon for his ongoing committment to the further development of this engine. For those that appreciate the aesthetics of the original game along with improved functionality, there is no replacement.

Travail was also tested successfully in:

glquakebjp http://user.tninet.se/~xir870k/
- Many thanks to aguirRe for his ongoing development of the gl scented version of the engine

JoeQuake http://www.runecentral.com/joequake/downloads.html
- Use 'loadsky x' at the console to implement and change the sky. 
 Skyboxes associated with each level are:
 -- 'qt_predator_' in start
 -- 'dusk' in qte1m1, qte1m2, qte1m3
 -- 'void' in qte1m4, qte1m5
 -- 'miramar' in qte2m1, qte2m2, qte2m3, qte2m4
 -- 'stars' in qtfin1
 -- 'captivation-blue_' in qtfin2, qtfin3

Dark Places http://icculus.org/twilight/darkplaces/files/?M=D
- Big thanks to LordHavoc for making changes to this engine so that Travail can run relatively fault free. You may find yourself being sniped at by enemies "outside" the level ocassionally, and in some cases you may be unable to get 100% kills. Alas, monsterous compile times meant that in some cases brushwork couldn't be altered to relieve this problem.

Along with '-game x' in the command line, you'll also need to up the RAM allocated to Quake. We suggest adding '-heapsize 65536' to the line (131072 if you can afford it).

For good reason, none of the Travail levels are vised with transparent water, and that is the way it should stay! We recommend using '+r_oldwater 0 +r_waterquality 32' in the command line for FitzQuake. If you are using other engines you'll need to change water variables to suit.

Travail will load into the new demos. To start a new SP mission, choose 'single player' then 'new game' from the main menu: you will be ported to the Travail start map where you may choose skill level and episode. 

C. The Soundtrack

The Travail Soundtrack can be downloaded in a separate archive. 

http://www.quaddicted.com/filebase/travail_soundtrack.zip

We recommend you play Travail with this specific soundtrack at least once, as it really does add to the experience. 

****************
III. THE BASICS OF PLAY

A. Goal of the Game

As with the original Quake, Travail has two basic goals. First, stay alive. Second, get out of the place you're in. The mysterious base from which you start contains two portals to alternate dimensions. When you complete an entire dimension (this takes four to six levels depending on route choice), you should have two Runes in your posession and be facing a portal which returns you to the start. 

B. Skill

When you first enter the apparently abandoned base you'll find three air lifts that will drop you near teleportals. The teleportal you go through selects the Skill level indicated at the base of air lift. In effect, the teleportals set your latent protection level from High (level 3) to Non-existent (level 0).

The portal that sets skill to nightmare and strips you of all protection is hidden.

C. Episode

Two large teleport chambers reside in the base proper. The portal in chamber one will take you to the dimension ruled by the Engineers of Destruction. The portal in chamber two, to the dimension governed by the Architects of Fear. You can visit the dimensions in any order you like.

****************
IV. MODIFICATIONS

A. Firepower
   
You will not find a DBS is the realm of the Architects of Fear. Instead, you will re-discover the power of the riot-controller. Enjoy!

B. Ammo

Remains unchanged.

C. Power-ups

You may come across an archane artifact resembling three large spikes. The Architects of Fear once stole this from another dimension, but have apparently forgotten about it. This 'Trinity' will increase the damage dealt by any weapon that uses spikes.

You might also stumble across a Pentagram of Protection that regenerates itself.

D. Bad Guys

Scrag - Have you ever wondered where these things come from? If you can make it through the realm of the Engineers of Destruction you will discover the fountainhead � and she will then destroy you. 

Archenid - Forget Willy, this thing bites (literally). Its melee attacks are not too painful, unless it is able to inject you with poison, in which case you should sprint for the nearest health pack. The archenid has no ranged attack, unless you count launching its massive body at the player a ranged attack. A tonne of exoskeleton can kill instantly under the right circumstances.

Mega Enforcer - In the slightly paraphrased words of Lunaran, the enforcer corps has seen expansion.  The more skilled marksmen have been given thicker blue armour, a stronger blaster, and an additional grenade launcher.

Hyper Enforcer - Likewise, the elite among them get the most expensive toys available: red armour, spread-fire blaster, rocket launcher, and a recharging particle shield.  Pay attention to their shield so as not to waste ammo on them i.e., pelting them from a distance with a scattergun isn't likely to help you much.

Jugger - Tough, deadly and stupid. Their massive armour and tracking missiles can be a problem. Let�s hope you destroy them all before the next arcane artificial intelligence update kicks in. Some weapons are less useful against Juggers. 

E. Environmental Hazards and Effects

2nd-Gen Radioactive Waste Containers - Keep an eye out for these boxes of explosive toxic waste. They serve the same purpose as those in the original Quake mission, but in addition these can be moved around and jumped onto by the player. So, don�t be too quick to blow them up!

****************
V. MULTIPLAYER ACTION

A. Cooperative

Travail levels were designed to support up to 4 player coop gameplay. Most levels have a separate entry point specifically for coop players. 'Nightmare Skill' is recommended for coop play.

Coop players should be aware that the lifts in qte1m4 are one player only at all times due to telefragging issues. We apologise for the inconvenience, and suggest you send your strongest player down first. They can set up a beach-head and the rest can follow.

B. Deathmatch	

The Travail SP levels do not support DM gameplay. However, there are five DM levels included with the pack.

qtdm1: malplatz - an exercise in discovering how far one needs to twist a modern SP level (qtfin1 in fact) to make it playable as a DM level. Inspect qtfin1 and qtdm1 back to back for full effect. This level has been designed specifically for 4v4 matches. Use it instead of e1m2, go on... I dare you!

qtdm2: 16 of 8 then 1 - developed from a faithful copy of Q3TA's House of Decay. A modified part of this level forms an arena in one of the SP maps, so I decided to hive it off the SP level and complete it as a DM homage. However, it seems I can't say no to the gang at QuakeOne, including Yellow_No.5, who suggested that with the addition of another route across the level it might make a good CAx map. I added a basement run, stripped out all the items and put 16 DM starts in... that version goes up on the CAx server. To make the version distributed for public access to the server more interesting, Yellow suggested I make the level eight starts and full of goodies. So, I called on inertia to use his years of experience in modifying the server version. Happy fragging!

qtdm3: Uberskank - An exercise in re-skinning a la Travail episode 2. Made some brushwork changes to the original (Usher Recompiled) while at it. Definitely 2v2 or 3-6 player free for all. Currently running on some netquake servers, visit QuakeOne.com for info.

A special shout goes out to voodoochopsticks who dearly wanted to contribute to the DM side of Travail. Alas, the request came too late. Next time we'll come to you at the first voodoo!

****************
VI. CONTRIBUTORS

Special thanks to [Kona], nightbringer-nb, XeNoN-xen, and Edgecrusher-Leviathan-Ionous for adding impetus in the first instance. Each, in their distinctive way and time, kept the Quake flame burning. From the start this project sought to involve as many people as possible from the Quake community whether directly (via material support) or indirectly (via reference or homage). We hope in this, at least, we have succeeded.

Pax amici!

-----------------------------------------------
A. Travail Team

Paul (distrans) Brosche
- Project Lead
- Recruitment
- Conceptual Design and Coordination
- Soundtrack: http://www.quaddicted.com/filebase/travail_soundtrack.zip
- Sound design
	Episode one - Boss (with early help from necros)
	Episode two - Archenid
- Miscellaneous 2D graphics
- Level Tester (Easy)
- Level Designer
	start: y va tan (with vondur)
	qte2m1: tejido de cicatriz
	qte2m2: voces extranas (with CZG, American McGee & Q3TA team)
	qte2m3: punto de la infeccion
	qte2m4: excision
	qtfin1: hacia la fuente
	qtdm1: malplatz
	qtdm2: 16 of 8 then 1 (with Q3TA team & inertia)
        qtdm3: Uberskank

Jack (scragbait) Meacher
- Project Second
- Backstory Author
- demo2.dem
- Lead Tester (All difficulty levels)
- Level Designer
	qte1m1: piedracero
	qte1m2: aguenergia
	qte1m3: costarodillo
	qte1m4: el lugar feo
	qte1m5: envidia antigua
	qtfin2: finales de epocas
	qtfin3: puentaltrono

Kirk (neg!ke) Eichler
- Conceptual Design
	Episode two - Boss Archenid
- demo3.dem
- Level Tester (Hard)
- Teacher of new tricks to old progs
- Level Designer
	qt???: maneras misteriosas
	qt???: secretos mas profundos

Bengt (aguirRe) Jardrup 
- Technical Consultant
- Quality Assurance
- Coder: compile tools and test engines
  ( http://user.tninet.se/~xir870k )
- Scraggy's Hero
- korngogpvcvkqp qh eqqr5

Andrew (Preach) Denner
- Modeller
	Episode one - Uberscrag
	Finale - Azoth
- Skin Artist
	Episode one - Uberscrag
	Episode two - Archenids
	Episode two - Jugger
	Finale - Azoth
- Coder
	Azoth and misc.

...and by no means least

(Asaki)
- Coder extraordinaire: all mission parameters, 
a truly generous and gentle being.

-----------------------------------------------
B. Those Who Answered the Call

(Spirit)
- Travail site design
- Filespace provider & level/mod archivist http://www.quaddicted.com
- co-op tester

Jean-Philippe (JPL) Lambert
- Travail logo designer
- Miscellaneous 2D graphics (including the four horsemen in qte2m1)
- Beta Tester (Easy)

Mike (biff debris) Phillips
- Miscellaneous 2D graphics (including the new Oblivion explobox skin)
- Beta tester (Normal)
- DM tester

Dimitry (vondur) Svetlichny
- Beta tester (Hard)
- DM tester

(Baker, Phenom, Para and of course... Bizarrosouless!)
- demo1.dem

(Yellow_No.5, Rook, blitz, pope, inertia, scampie, trinca, bambuz)
- DM testers

(Kell & RPG)
- early co-op testers

(NahkahiiR)
- later co-op tester
 
-----------------------------------------------
C. They Provided Resources

Id - too much to mention (along with Raven, Rogue and Hipnotic)
John (metlslime) Fitzgibbons - Oblivion texture-set & Fitzquake
(stecki) - Decon texture-set
(Solecord) � webspace at QuakeOne
(lunaran) - the new mega & ultra enforcers
Ken Turner - the original Willy the Spider
The Impel Team - the original Juggernaut
Nihilism Unlimited - the Riot Controller
(hipshot) - Miramar skybox (ep2)
(kell) - the rest of the skyboxes, Quoth entities and various texture-sets
Ben Morris - Worldcraft
Mike Jackman - TexMex
Pete Callaway - QPedII
Rene Post - qME
Izware - Wings3d (modelling)
discreet - Gmax (skinmapping/animation/compiling models)
Spencer Kimball and Peter Mattis - Gimp (skins/art) 
The Quark team - Quark (conversion work)
Thank you to everyone who helped us get the assets we needed.

-----------------------------------------------
D. They Also Inspired - but are as yet unmentioned

ELEK, aardappel, CZG, Ogro, mindcrime, pjw, Gilt, Fat Controller, vigil, Electro, fingers, Bal, peej, DaMaul, Rorshach, Fern, Tronyn, tron, than, DaZ, Dranz, Mr Fribbles, Ace_Dave, LTH, Quernel, shambler, Glassman, Hrimfaxi, Kinn, UWF, madfox, trinca... y va tan.

****************
VII. LEGAL BOILERPLATE 

Quake (c) & (tm) id Software Inc. All rights reserved. 

All trademarks are the property of their respective companies. 

Travail (c) the Travail Team 2007 (see above)

You may distribute this archive, without modifying its contents, via the internet or BBS systems. Apart from that, you may play it...that's all, unless you have the express permission of ALL the Travail Team. Some of the stuff used herein is available via GPL, go forth and seek it out (we've provided enough info for you to do that at least).

****************
VIII. SPECIAL THANKS

SPECIAL THANKS AND APOLOGIES TO ANYONE WHOSE WORK APPEARED IN TRAVAIL THAT WE FORGOT OR COULD NOT IDENTIFY.

-----------------------------------------------
Jack (scragbait) Meacher would like to also add special thanks to: 

aguirRe: For rescuing me time and time again on every map I made for Travail. He also kept me motivated and pinged me from time to time to see that the project kept going. He answered all my questions and taught me a lot. You're playing these maps because he came through. Thanks!

aguirRe: For updating bsp, light and vis and for providing a modified version of GLQuake that could run even my sickest maps. Go here: http://user.tninet.se/~xir870k/

distrans: From QToo to Quake Travail - he is the original founder of this project and has lead it more than me, and for the better! He provides copious useful feedback and direction for my contributing maps. He is the keystone of the Travail team and keeps us working together. He made brushwork that appears in my maps (the porta slippy & entrance/exit in qtfin2) and, with some thematic suggestions from me, named them.

Asaki and Preach: For the boss models, skins and code that appear in my maps. They did very impressive work, and look and work great in my maps.

Asaki and aguirRe: For extra code that cleans out old id errors and add functionality needed to make Travail perform better.

The Quake Travail Team: distrans, Asaki, Preach, neg!ke, aguirRe. What an honor to work with so many talented people that made Travail such a great mod. It way exceeded the original expectations at the start of the project. Thanks for working with me.

The ex-QToo and Quake Travail Partners: Leviathan - he had the spirit but not the time; necros - he created the working prototype of the Uberscrag which was completed by Preach and Asaki

Linda: For being my mate and for taking some interest in this baffling past time that eats time beyond reason. Big squeezes!

You: For downloading and playing this level. I hope it fed your appetite for this classic game that is still loved by many.

-----------------------------------------------
Kirk (neg!ke) Eichler would like to also add special thanks to:

...the team, all contributors/supporters, and the players of course.

-----------------------------------------------
Paul (distrans) Brosche would like to offer special thanks to:

Jack Meacher: for all the help, support and comradeship offered so freely over the last seven years. A true friend! 

Also, thanks to my erstwhile muses: Asurfael, Stephanie Marshall, Naomi Watts, and of late... Kate Grealy, Missy Higgins & Bambuz.