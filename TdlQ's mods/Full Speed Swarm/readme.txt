What exactly does this mod do?
------------------------------

 1/ Normal behavior of a cop
First, let's define what is the normal behavior of a cop as it's a really
important notion to understand how FSS can affect difficulty, depending on the
hardware you use.

Imagine there are only you and one unique cop all over the map. Unless your
frame rate is really low (below 15 fps), the cop is performing at his maximum
level of planned efficiency (all reaction delays and check intervals specified
by OVERKILL are respected). I consider this as the reference of what OVERKILL
designed and wanted in terms of difficulty.

 2/ Responsiveness
Before Update 173, task throughput was equal to host's frame rate; it is now
set to 60 tasks per second. Above a particular number, more cops means more
gap between specified delays/intervals and what really happens.

Steps:
a/ an AI refreshes its sight sense and sees something new;
b/ it takes the decision to change its focus (or not);
c/ it applies stare/pause defined delays to simulate human reaction times.

With a throughput too low, AI's eyes aren't refreshed fast enough, an unwanted
delay is introduced in step a and their reflexes get degraded.

 3/ Unleash'em all!
This is where Full Speed Swarm comes into play: it lets the game execute
more than 1 task per frame (the slider in the options menu sets the maximum
for this ; remember it's a max and not a min). So even with 100 cops on the
map, they can all perform as well as if they were alone (at least, the gap
between what they should be and what they are is greatly reduced).

With this point in mind, you can now understand how Full Speed Swarm does not
add difficulty, it just helps to reach what was originally designed.


Are there any drawbacks?
------------------------

No. Executing more tasks increases CPU workload so I've optimized a lot of
things (unchanged behavior, faster process) and frame rate won't go down even
on low-end computers. In case it still makes too much of a difference, you can
adjust the maximum tasks throughput in the options menu.


Additional features
-------------------

On my way to optimize whatever I could, I've added to some of the rewritten
function a few off-topic things.

 1/ Stealth
During stealth, the maximum interval between 2 sight refreshes is set to a
significantly shorter value to prevent civilians starting to notice very
quickly a player after he already got too close.

 2/ Domination process
Friendly AI don't shoot at cops that players are trying to intimidate.

 3/ BLT's Delayed Calls
As I wasn't happy with the original implementation, I've replaced this library
by one with, on top of being faster, a functional Remove() method and that
supports for repetitive calls.

 4/ Adaptive LOD updater
It's the thing that gives animation priority to characters in the center of
your screen. If there are too many cops, the original updater can't process it
all in time and the cops you are focusing on look very laggy. Instead of
always processing 1 character per frame, the new system does 1 per group of 25
per frame, giving a much smoother result with very high number of cops.

 5/ Walking quality
Setting this option to "very high" will override the LOD value, making sure a
visible character is moved at least once every 2 frames. "Ultra" does the same
except visible characters are moved at every frame.

 6/ Fast-paced game (option)
Disabled by default, this option enhances the difficulty by removing several
delays punctuating cops' behavior. Cops won't run faster, they won't deal more
damage, they'll just wait less between each of their actions.

 7/ Improved chase (option)
Apply Iter's path extender to all cops, making them reaching players much faster.

 8/ Nervous game (option)
Enemies' reactions escalate faster. It can be summed up by: aim less, shoot more!

 9/ Custom assault (option)
Cops don't rush in straight lines, see comparison at https://youtu.be/-T2c3NjRtxI

 10/ Cop awareness (option)
Make cops to face their enemies and shoot more at them while they move.

 11/ Spawn delay (option)
A spawn kill executed at close range of related point delays its next spawn.
It's meant to prevent excessive enemy flood when you're sitting on a spawn point.

 12/ "Big Party" mutator
A mutator inspired by GoonMod's Excessive Force. The original one spawns more
than 2000 cops, nothing can handle that, here you can define approximatively
how many cops you will fight by setting its parameter.

 13/ "Real Elastic" mutator
It decreases maximum number of cops, activates all FSS's gameplay changing
options and removes grace period for players. Requires Iter.

