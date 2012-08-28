## Post-48hr Update/Bugfix

This version is not for rating - merely for my own sense of completion :)


### August 28

 - death screen originally only required ANY key to skip, which resulted in sometimes not seeing one's score.  There's also a slight delay before skipping
 - tweaked the physics of exiting a swing
 - added PAUSE via the 'P' key or losing focus
 - **items**
	 - added non-magnetic items (for bonuses and the like)
	 - added sky-level items, which 
 - some (minor) commenting and cleanup of the source
 - made it so that if the player gets past the generated islands (or "buildings" as I call them) then the game will wait until it's caught up rather than letting you fall off into oblivion :)
 - distance counter is now actually based on distance travelled
	- previously this was based on horizontal velocity which allowed you to up your distance count by swinging in circles or running against a wall
 - upped the maximum speed setting (perhaps temporarily) so that I could fix a few of the bugs associated with high speed travel.  This may have made the game un-fun but I don't know any more
 - tried a variation on the "exit velocity" when leaping out of a swing
 - added a .gitignore file
