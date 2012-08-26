package
{
	import net.flashpunk.Sfx;

	public class Assets
	{
		[Embed(source = "assets/tiles.png")] public static const TILES:Class;
		[Embed(source = "assets/brain.png")] public static const BRAIN:Class;
		[Embed(source = "assets/tree 3.png")] public static const TREE:Class;
		[Embed(source = "assets/ape_sheet.png")] public static const PLAYER:Class;
		[Embed(source = "assets/sky.png")] public static const SKY:Class;
		[Embed(source = "assets/ape profile.png")] public static const APE_PROFILE:Class;	
		[Embed(source = "assets/ape_arm.png")] public static const APE_ARM:Class;
		[Embed(source = "assets/mountains.png")] public static const MOUNTAINS:Class;
		
		
		[Embed(source = "assets/particle_dust.png")] public static const PARTICLE_DUST:Class;
		[Embed(source = "assets/particle_leaf_anim.png")] public static const PARTICLE_LEAF:Class;
		
		
		
		[Embed(source = "assets/audio/step-00.mp3")] public static const SND_STEP_00:Class;
		[Embed(source = "assets/audio/step-01.mp3")] public static const SND_STEP_01:Class;
		[Embed(source = "assets/audio/step-02.mp3")] public static const SND_STEP_02:Class;
		[Embed(source = "assets/audio/step-03.mp3")] public static const SND_STEP_03:Class;
		[Embed(source = "assets/audio/step-04.mp3")] public static const SND_STEP_04:Class;
		[Embed(source = "assets/audio/step-05.mp3")] public static const SND_STEP_05:Class;
		[Embed(source = "assets/audio/step-06.mp3")] public static const SND_STEP_06:Class;
		public static var footStepResources:Array = [SND_STEP_00, SND_STEP_01, SND_STEP_02, SND_STEP_03, 
			SND_STEP_04, SND_STEP_05, SND_STEP_06];
		public static var footStepSound:MultiSound = new MultiSound(footStepResources);
		
		
		
		[Embed(source = "assets/audio/jump-00.mp3")] public static const SND_JUMP_00:Class;
		[Embed(source = "assets/audio/jump-01.mp3")] public static const SND_JUMP_01:Class;
		[Embed(source = "assets/audio/jump-02.mp3")] public static const SND_JUMP_02:Class;
		[Embed(source = "assets/audio/jump-03.mp3")] public static const SND_JUMP_03:Class;
		[Embed(source = "assets/audio/jump-04.mp3")] public static const SND_JUMP_04:Class;
		[Embed(source = "assets/audio/jump-05.mp3")] public static const SND_JUMP_05:Class;
		[Embed(source = "assets/audio/jump-06.mp3")] public static const SND_JUMP_06:Class;
		[Embed(source = "assets/audio/jump-07.mp3")] public static const SND_JUMP_07:Class;		
		public static var jumpResources:Array = [SND_JUMP_00,SND_JUMP_01, SND_JUMP_02, SND_JUMP_03, 
			SND_JUMP_04, SND_JUMP_05, SND_JUMP_06];
		public static var jumpSound:MultiSound = new MultiSound(jumpResources);
		
		[Embed(source = "assets/audio/landing-00.mp3")] public static const SND_LAND_00:Class;
		[Embed(source = "assets/audio/landing-01.mp3")] public static const SND_LAND_01:Class;
		[Embed(source = "assets/audio/landing-02.mp3")] public static const SND_LAND_02:Class;
		[Embed(source = "assets/audio/landing-03.mp3")] public static const SND_LAND_03:Class;
		public static var landingResources:Array = [SND_LAND_00,SND_LAND_01, SND_LAND_02, SND_LAND_03];
		public static var landingSound:MultiSound = new MultiSound(landingResources);
		
		[Embed(source = "assets/audio/foyer_music.mp3")] public static const MUS_FOYER:Class;
		public static var foyerMusic:Sfx = new Sfx(MUS_FOYER);
		public function Assets()			
		{
		
		}
	}
}