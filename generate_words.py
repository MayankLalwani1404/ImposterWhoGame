import os
import json

RAW_DATA = {
    'everyday_objects': [
        "Keys|Opens things up", "Wallet|Keeps cards safe", "Phone|Pocket communicator", "Toothbrush|Morning bristle", 
        "Mug|For hot liquids", "Lamp|Desk brightener", "Backpack|Shoulder storage", "Umbrella|Keeps you dry", 
        "Scissors|Makes things shorter", "Comb|Tangles no more", "Curtain|Blocks the view", "Pillow|Soft block", 
        "Blanket|Nighttime layer", "Clock|Has hands but no arms", "Mirror|Shows the truth", "Towel|Gets wetter as it dries", 
        "Soap|Slippery cleaner", "Sponge|Porous scrubber", "Broom|Dust mover", "Trash Can|Eats paper",
        "Pen|Ink dispenser", "Pencil|Requires sharpening", "Notebook|Lined pages", "Stapler|Metal fastener",
        "Tape|Sticky strip", "Chair|Four legged rest", "Table|Flat elevated surface", "Couch|Multi-person seat",
        "Television|Moving pictures", "Remote|Button clicker", "Battery|Cell power", "Charger|Cable juice",
        "Headphones|Personal audio", "Glasses|Facial frames", "Watch|Wrist accessory", "Ring|Circular band",
        "Necklace|Hangs around", "Earrings|Lobe decor", "Shoe|Has a sole", "Sock|Worn inside out"
    ],
    'famous_people': [
        "Albert Einstein|E=mc squared", "Michael Jackson|Moonwalker", "Marilyn Monroe|Classic Hollywood blonde", "Elvis Presley|Hound dog singer",
        "Abraham Lincoln|Penny face", "George Washington|Quarter face", "Cleopatra|Ancient ruler", "William Shakespeare|To be or not to be",
        "Leonardo da Vinci|Renaissance man", "Isaac Newton|Felt the bump", "Winston Churchill|Cigar smoking PM", "Martin Luther King Jr|Civil rights icon",
        "Nelson Mandela|Robben Island prisoner", "Mahatma Gandhi|Salt march leader", "Mother Teresa|Calcutta helper", "Charles Darwin|Natural selection",
        "Galileo Galilei|Looked at stars", "Marie Curie|Radioactive researcher", "Steve Jobs|Turtleneck visionary", "Bill Gates|Windows creator",
        "Mark Zuckerberg|Social networker", "Elon Musk|Mars dreamer", "Jeff Bezos|Prime billionaire", "Oprah Winfrey|You get a car!",
        "Ellen DeGeneres|Dancing host", "Tom Cruise|Does his own stunts", "Will Smith|Slapped at Oscars", "Brad Pitt|Ocean's eleven actor",
        "Angelina Jolie|Maleficent", "Leonardo DiCaprio|Finally won an Oscar", "Johnny Depp|Captain Jack", "Robert Downey Jr|Avenger genius",
        "Chris Evans|First Avenger", "Chris Hemsworth|Aussie Avenger", "Scarlett Johansson|Black Widow", "Jennifer Lawrence|Mockingjay"
    ],
    'food_drinks': [
        "Pizza|Cheesy triangles", "Burger|Meat between buns", "Sushi|Seaweed roll", "Pasta|Boiled carbs",
        "Taco|Folded shell", "Steak|Well done or rare", "Salad|Bowl of leaves", "Soup|Eaten with a spoon",
        "Coffee|Roasted bean water", "Juice|Squeezed fruit", "Beer|Hoppy beverage", "Wine|Aged in barrels",
        "Water|Essential liquid", "Soda|Fizzy pop", "Tea|Steeped bag", "Milk|Cereal liquid",
        "Cheese|Aged dairy", "Butter|Melted on toast", "Bread|Sliced loaf", "Bagel|Boiled then baked",
        "Croissant|Flaky crescent", "Donut|Sweet ring", "Cake|Sliced pastry", "Pie|Fruity crust",
        "Cookie|Chocolate chipped", "Brownie|Fudgy square", "Ice Cream|Eaten from a cone", "Popsicle|On a stick",
        "Chocolate|Sweet cocoa", "Candy|Wrapper treats", "Apple|Teacher's fruit", "Banana|Peel carefully"
    ],
    'animals': [
        "Lion|Mane ruler", "Tiger|Forest stripes", "Elephant|Heavy stomper", "Giraffe|Tallest of all",
        "Zebra|Black and white runner", "Monkey|Banana eater", "Kangaroo|Pouch holder", "Penguin|Waddling bird",
        "Dolphin|Clicking swimmer", "Shark|Fin in the water", "Whale|Blowhole breather", "Bear|Honey lover",
        "Wolf|Pack hunter", "Fox|Bushy tail", "Dog|Barks at mail", "Cat|Chases lasers",
        "Mouse|Cheese lover", "Rat|Maze runner", "Rabbit|Long ears", "Squirrel|Acorn hider",
        "Frog|Lily pad hopper", "Snake|No legs", "Turtle|Slow walker", "Lizard|Regrows tail"
    ],
    'brands_logos': [
        "Apple|Bitten fruit", "Nike|Swoosh mark", "Coca-Cola|Red label soda", "Google|Primary colors search", 
        "Microsoft|Four colored squares", "Amazon|A to Z arrow", "Adidas|Three slanted lines", "Pepsi|Red white blue globe", 
        "McDonalds|Golden letter", "Samsung|Blue ellipse", "Toyota|Intersecting ovals", "Honda|Silver H",
        "Sony|Electronics giant", "Disney|Castle logo", "Netflix|Red N", "Spotify|Three sound waves",
        "Tesla|Electric T", "Ford|Blue oval", "BMW|Bavarian motor", "Mercedes|Three point star",
        "Gucci|Double G", "Louis Vuitton|LV monogram", "Chanel|Interlocking C", "Prada|Milano fashion",
        "Rolex|Crown logo", "Starbucks|Twin-tailed siren", "Subway|Eat fresh", "KFC|Colonel's face"
    ],
    'colors_shapes': [
        "Red|Stop sign color", "Blue|Ocean color", "Green|Leaf color", "Yellow|Banana color", 
        "Purple|Grape color", "Orange|Carrot color", "Circle|No corners", "Square|Four even sides", 
        "Triangle|Pyramid face", "Rectangle|Long box", "Hexagon|Honeycomb cell", "Oval|Egg silhouette",
        "Pink|Flamingo shade", "Brown|Bark shade", "Black|Night sky", "White|Cloud shade",
        "Grey|Stormy sky", "Cyan|Printer ink", "Magenta|Pinkish purple", "Turquoise|Gemstone shade",
        "Diamond|Baseball field", "Star|Five points", "Heart|Organ shape", "Crescent|Bitten cookie",
        "Octagon|UFC ring", "Pentagon|DC building", "Sphere|Globe shape", "Cube|Dice shape"
    ],
    'countries_cities': [
        "USA|50 stars", "UK|Island monarchy", "France|Baguette origin", "Germany|Pretzel origin",
        "Japan|Island of the sun", "China|Largest population", "India|Curry origin", "Brazil|Amazon home",
        "Canada|Polite neighbor", "Australia|Down under", "New York|Never sleeps", "London|Double decker buses",
        "Paris|Luminous city", "Rome|Gladiator home", "Tokyo|Crowded crossing", "Beijing|Forbidden walls",
        "Moscow|Chilly capital", "Berlin|Divided wall", "Madrid|Tapas capital", "Barcelona|Gaudi architecture"
    ],
    'emotions_feelings': [
        "Happiness|Smiling state", "Sadness|Teary state", "Anger|Red faced state", "Fear|Shivering state", 
        "Surprise|Jaw dropped", "Disgust|Wrinkled nose", "Love|Heart fluttering", "Jealousy|Green eyed monster", 
        "Guilt|Heavy conscience", "Pride|Chest puffed", "Shame|Looking away", "Anxiety|Biting nails",
        "Excitement|Jumping up", "Boredom|Yawning heavily", "Confusion|Scratching head", "Curiosity|Asking why",
        "Hope|Fingers crossed", "Nostalgia|Thinking of yesterday", "Relief|Deep exhale", "Frustration|Pulling hair",
        "Awe|Wide eyed wonder", "Sympathy|Feeling for another", "Empathy|Feeling with another", "Loneliness|Solo blues",
        "Gratitude|Saying thanks", "Contentment|Peaceful rest", "Greed|Wanting it all", "Resentment|Holding a grudge"
    ],
    'hobbies_activities': [
        "Reading|Flipping pages", "Writing|Jotting down", "Drawing|Sketching lines", "Painting|Mixing palettes", 
        "Photography|Focusing lenses", "Gaming|Button mashing", "Cooking|Following recipes", "Baking|Measuring flour", 
        "Gardening|Watering soil", "Fishing|Casting lines", "Hiking|Uphill walking", "Cycling|Pedaling fast",
        "Yoga|Holding poses", "Meditation|Deep breathing", "Dancing|Feeling the beat", "Singing|Hitting notes",
        "Knitting|Clicking needles", "Sewing|Pushing pins", "Woodworking|Sawing planks", "Pottery|Spinning clay",
        "Swimming|Doing laps", "Running|Pounding pavement", "Camping|Pitching tents", "Surfing|Paddling out",
        "Skateboarding|Doing tricks", "Skiing|Holding poles", "Snowboarding|Carving powder", "Rock Climbing|Chalking hands"
    ],
    'internet_culture': [
        "Meme|Funny internet picture", "Viral|Everyone saw it", "Influencer|Has sponsors", "Troll|Bothers people", 
        "Clickbait|You won't believe", "Hashtag|Sorting tag", "Emoji|Text picture", "Selfie|Front camera", 
        "Vlog|Daily video", "Podcast|Audio conversation", "Stream|Live broadcast", "Trend|Currently happening",
        "Tiktok|Swiping app", "Twitter|Short text app", "Instagram|Square photos", "Reddit|Sub-communities",
        "Google|I'm feeling lucky", "Wikipedia|Anyone can edit", "YouTube|Subscribe button", "Twitch|Gamer streaming",
        "GIF|Looping animation", "DM|Sliding in", "Bitcoin|Digital coin", "NFT|Expensive jpeg",
        "Avatar|Profile picture", "Bio|About me", "Follower|Keeping up", "Like|Double tap"
    ],
    'kitchen_cooking': [
        "Knife|Sharp edge", "Fork|Four prongs", "Spoon|Curved head", "Plate|Dinner disc", 
        "Bowl|Cereal holder", "Cup|Handle-less drinkware", "Glass|Fragile drinkware", "Pan|Shallow cooker", 
        "Pot|Deep cooker", "Oven|Hot box", "Stove|Burner top", "Microwave|Rotating heater", 
        "Fridge|Cold box", "Freezer|Ice box", "Blender|Whirling blades", "Toaster|Pop up heater",
        "Spatula|Flipping accessory", "Whisk|Wire loops", "Tongs|Pinching grabs", "Peeler|Skin remover",
        "Cutting Board|Wooden surface", "Colander|Holey bowl", "Measuring Cup|Scale lines", "Rolling Pin|Cylindrical flattener",
        "Dishwasher|Automated cleaner", "Sink|Faucet basin", "Trash Can|Rubbish bin", "Pantry|Dry food closet"
    ],
    'movies_tv': [
        "Star Wars|Far far away", "Harry Potter|Platform 9 3/4", "Lord of the Rings|Mount Doom", "Marvel|Stan Lee cameos", 
        "Batman|Gotham protector", "Superman|Kryptonite weakness", "Spider-Man|Great responsibility", "Pulp Fiction|Briefcase glowing", 
        "The Godfather|An offer you cannot refuse", "Friends|Central Perk", "The Office|Dunder Mifflin", "Stranger Things|The Upside Down",
        "The Matrix|Taking the red pill", "Jurassic Park|Mosquito in amber", "Titanic|Iceberg ahead", "Avatar|Blue CGI aliens",
        "Inception|Spinning top", "The Lion King|Hakuna Matata", "Toy Story|You've got a friend in me", "Finding Nemo|Just keep swimming",
        "Game of Thrones|Iron throne", "Breaking Bad|Walter White", "The Simpsons|Springfield residents", "Spongebob|Krusty Krab",
        "Doctor Who|TARDIS traveler", "Sherlock|Baker Street", "Black Mirror|Screen reflection", "The Mandalorian|This is the way"
    ],
    'music_bands': [
        "The Beatles|Abbey Road crossers", "Queen|We will rock you", "Nirvana|Smells like teen spirit", "Coldplay|Viva la vida", 
        "Metallica|Enter sandman", "Pink Floyd|The wall", "AC/DC|Thunderstruck", "Rolling Stones|Paint it black", 
        "U2|Beautiful day", "Led Zeppelin|Immigrant song", "Guns N Roses|Sweet child o mine", "Eminem|Lose yourself",
        "Michael Jackson|Thriller dance", "Elvis Presley|Jailhouse rock", "Madonna|Material girl", "Beyonce|Single ladies",
        "Taylor Swift|Shake it off", "Ed Sheeran|Thinking out loud", "Adele|Hello from the other side", "Rihanna|Work work work",
        "Drake|Hotline bling", "Kanye West|Stronger", "Justin Bieber|Sorry", "Ariana Grande|Thank u next",
        "Billie Eilish|Ocean eyes", "The Weeknd|Starboy", "Bruno Mars|Locked out of heaven", "Post Malone|Circles"
    ],
    'occupations': [
        "Doctor|Wears a stethoscope", "Nurse|Assists in hospital", "Teacher|Grades papers", "Police|Wears a badge", 
        "Firefighter|Slides down pole", "Engineer|Calculates structures", "Lawyer|Argues in court", "Accountant|Does the taxes", 
        "Chef|Wears a tall hat", "Pilot|Sits in cockpit", "Astronaut|Floats in zero G", "Plumber|Unclogs drains",
        "Electrician|Checks the circuits", "Carpenter|Works with timber", "Mechanic|Looks under the hood", "Barber|Uses clippers",
        "Dentist|Checks for cavities", "Veterinarian|Cures pets", "Architect|Draws blueprints", "Scientist|Wears a lab coat",
        "Farmer|Drives a tractor", "Fisherman|Casts a net", "Miner|Wears a hard hat with a light", "Soldier|Wears camouflage",
        "Artist|Mixes colors", "Musician|Reads sheet music", "Actor|Memorizes lines", "Writer|Meets word counts"
    ],
    'school_education': [
        "Math|Addition and subtraction", "Science|Lab goggles", "History|Memorizing dates", "Geography|Looking at globes", 
        "English|Writing essays", "Art|Drawing class", "Music|Playing instruments class", "PE|Running laps", 
        "Physics|Forces and motion", "Chemistry|Test tubes", "Biology|Dissecting frogs", "Literature|Analyzing poems",
        "Algebra|Finding X", "Geometry|Protractors and compasses", "Calculus|Derivatives and integrals", "Astronomy|Looking through telescopes",
        "Philosophy|Deep thoughts", "Psychology|Studying behavior", "Sociology|Studying groups", "Economics|Supply and demand",
        "Teacher|At the front of class", "Student|Raising hand", "Principal|In the main office", "Homework|Due tomorrow",
        "Exams|No talking allowed", "Textbook|Heavy backpack item", "Whiteboard|Dry erase markers", "Recess|Playing outside"
    ],
    'science_technology': [
        "Computer|Keyboard and mouse", "Internet|Connected network", "AI|Machine learning", "Robot|Mechanical being", 
        "Space|Beyond the atmosphere", "Planet|Orbits a star", "Star|Burning gas ball", "Galaxy|Billions of stars", 
        "Chemistry|Periodic table", "Physics|Theoretical study", "Biology|Cellular structure", "Mathematics|Equations",
        "Smartphone|App device", "Tablet|Touch screen only", "Laptop|Foldable device", "Microchip|Integrated circuit",
        "Software|Code execution", "Hardware|Motherboard and RAM", "Data|Ones and zeros", "Algorithm|Logic sequence",
        "Microscope|Slides and lenses", "Telescope|Observatory tool", "Laser|Optical amplification", "DNA|Double helix",
        "Atom|Protons and neutrons", "Molecule|Chemical bond", "Gravity|Newton's apple", "Evolution|Survival of the fittest"
    ],
    'sports': [
        "Soccer|No hands allowed", "Basketball|Dribbling", "Baseball|Hitting a home run", "Tennis|Serving an ace", 
        "Golf|Putting on the green", "Swimming|Wearing goggles", "Running|Crossing the finish line", "Cycling|Wearing a helmet", 
        "Volleyball|Spiking down", "Rugby|Scoring a try", "Cricket|Bowling the ball", "Boxing|Knockout punch",
        "Football|Throwing a touchdown", "Hockey|Slap shot", "Wrestling|Pinning shoulders", "MMA|Tap out",
        "Gymnastics|Balance beam", "Figure Skating|Triple axel", "Surfing|Catching a barrel", "Skateboarding|Ollie and kickflip",
        "Skiing|Slalom course", "Snowboarding|Halfpipe tricks", "Archery|Bullseye target", "Fencing|En garde",
        "Bowling|Hitting a strike", "Billiards|Eight ball corner pocket", "Darts|Hitting a 180", "Badminton|Smashing the shuttle"
    ],
    'superheroes': [
        "Superman|Red cape", "Batman|Bat signal", "Spider-Man|Swinging through NY", "Iron Man|Arc reactor", 
        "Captain America|Vibranium shield", "Thor|Mjolnir hammer", "Hulk|Smashes things", "Wolverine|Healing factor", 
        "Flash|Central city speedster", "Wonder Woman|Lasso of truth", "Aquaman|Trident king", "Black Panther|Wakanda forever",
        "Doctor Strange|Eye of Agamotto", "Ant-Man|Pym particles", "Captain Marvel|Binary power", "Deadpool|Fourth wall breaker",
        "Green Lantern|Construct ring", "Cyborg|Booyah", "Martian Manhunter|Oreos fan", "Green Arrow|Star City archer",
        "Black Widow|Red room assassin", "Hawkeye|Never misses", "Scarlet Witch|Hex powers", "Vision|Mind stone",
        "Daredevil|Blind lawyer", "Punisher|Skull shirt", "Ghost Rider|Motorcycle spirit", "Blade|Daywalker"
    ],
    'transportation': [
        "Car|Steering wheel", "Bus|Has many rows of seats", "Train|Conductor aboard", "Airplane|Takes off from runway", 
        "Bicycle|Needs balance", "Motorcycle|Requires a helmet", "Boat|Floating vessel", "Ship|Has a captain", 
        "Helicopter|Lands on a helipad", "Subway|Underground transit", "Taxi|Yellow cab", "Tram|Cable car",
        "Truck|18 wheeler", "Van|Sliding side door", "Jeep|Top down driving", "Scooter|Kick and ride",
        "Skateboard|Grip tape", "Rollerblades|Wheels on feet", "Submarine|Periscope user", "Ferry|Carries cars over water",
        "Hot Air Balloon|Propane burner", "Blimp|Goodyear skyride", "Spaceship|Zero gravity travel", "Rocket|Countdown sequence",
        "Ambulance|Sirens blaring", "Fire Truck|Red emergency vehicle", "Police Car|Light bar on top", "Garbage Truck|Compacts waste"
    ],
    'video_games': [
        "Mario|Jumps on goombas", "Zelda|Triforce hero", "Pokemon|Pikachu's franchise", "Minecraft|Creepers and zombies", 
        "Fortnite|Gliding in", "Call of Duty|First person shooter", "GTA|Los Santos", "Halo|Cortana's companion", 
        "Sonic|Collected rings", "Tetris|Clearing lines", "Pac-Man|Running from ghosts", "Sims|Speaking Simlish",
        "Skyrim|Fus Ro Dah", "Witcher|Geralt of Rivia", "Fallout|Vault boy", "Mass Effect|Commander Shepard",
        "Overwatch|Payload escort", "Valorant|Spike defuse", "League of Legends|Summoner's Rift", "Dota|Valve MOBA",
        "Super Smash Bros|Final destination", "Street Fighter|Hadouken", "Mortal Kombat|Fatality", "Tekken|King of Iron Fist",
        "Animal Crossing|Tom Nook's debt", "Stardew Valley|Pelican Town", "Portal|The cake is a lie", "Half-Life|Crowbar hero"
    ],
    'weather_nature': [
        "Sun|Provides vitamin D", "Rain|Needs an umbrella", "Snow|Makes it white", "Cloud|Blocks the light", 
        "Wind|Blows things away", "Storm|Stay indoors", "Lightning|Bright flash", "Thunder|Rumbles loud", 
        "Tornado|Funnel cloud", "Hurricane|Category 5", "Earthquake|Richter scale", "Volcano|Erupting magma",
        "Fog|Low visibility", "Hail|Ice from the sky", "Rainbow|Pot of gold at end", "Meteor|Shoots across sky",
        "River|Flows to the sea", "Lake|Surrounded by land", "Ocean|Home to coral", "Waterfall|Plunging stream",
        "Mountain|Requires climbing", "Valley|Low basin", "Forest|Full of pine cones", "Desert|Cacti habitat",
        "Jungle|Dense canopy", "Swamp|Muddy bog", "Cave|Stalactites", "Island|Tropical getaway",
        "Tree|Trunk and branches", "Flower|Petals and pollen", "Grass|Needs mowing", "Dirt|Muddy when wet"
    ]
}

output = {}

for cat, records in RAW_DATA.items():
    cat_items = []
    for r in records:
        w, h = r.split('|')
        cat_items.append({"word": w, "hint": h})
    output[cat] = cat_items

data_dir = '/home/mayank/Portfolio_projects/ImposterWho/imposterwhogame/assets/data'
os.makedirs(data_dir, exist_ok=True)
with open(os.path.join(data_dir, 'words.json'), 'w') as f:
    json.dump(output, f, indent=2)

print("Generated curated words.json")
