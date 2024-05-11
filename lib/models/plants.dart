class Plant {
  final int plantId;
  final String size;
  final double rating;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Plant(
      {required this.plantId,
        required this.category,
        required this.plantName,
        required this.size,
        required this.rating,
        required this.imageURL,
        required this.isFavorated,
        required this.decription,
        required this.isSelected});

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
        plantId: 0,
        category: 'Tomato',
        plantName: 'Bacterial Spot',
        size: 'Small',
        rating: 4.5,
        imageURL: 'assets/images/Bacterial_Spot.png',
        isFavorated: true,
        decription:
        'PossibleCauses - Xanthomonas bacteria which can be introduced into a garden on contaminated seed and transplants, which may or may not show symptoms.'
            '\n\nPossibleSolution - Remove symptomatic plants from the field or greenhouse to prevent the spread of bacteria to healthy plants.',
        isSelected: false),
    Plant(
        plantId: 1,
        category: 'Tomato',
        plantName: 'Early Blight',
        size: 'Medium',
        rating: 4.8,
        imageURL: 'assets/images/Early_Blight.png',
        isFavorated: false,
        decription:
        'PossibleCauses - The fungus Alternaria solani, high humidity and long periods of leaf wetness.'
         '\n\nPossibleSolution - Maintaining optimum growing conditions: proper fertilization, irrigation, and pests management.',
        isSelected: false),
    Plant(
        plantId: 2,
        category: 'Tomato',
        plantName: 'Late Blight',
        size: 'Large',
        rating: 4.7,
        imageURL: 'assets/images/Late_Blight.png',
        isFavorated: false,
        decription:
        'PossibleCauses - Caused by the water mold Phytophthora infesting.'
        '\n\nPossibleSolution - Timely application of fungicide',
        isSelected: false),
    Plant(
        plantId: 3,
        category: 'Potato',
        plantName: 'Early Blight',
        size: 'Small',
        rating: 4.5,
        imageURL: 'assets/images/P_Early_Blight.png',
        isFavorated: false,
        decription:
        'PossibleCauses - The fungus Alternaria solani, high humidity and long periods of leaf wetness.'
        '\n\nPossibleSolution - Maintaining optimum growing conditions: proper fertilization, irrigation, and pests management.',
        isSelected: false),
    Plant(
        plantId: 4,
        category: 'Potato',
        plantName: 'Late Blight',
        size: 'Large',
        rating: 4.1,
        imageURL: 'assets/images/P_Late_Blight.png',
        isFavorated: true,
        decription:
        'PossibleCauses - Occurs in humid regions with temperatures ranging between 4 and 29 °C.'
        '\n\nPossibleSolution - Eliminating cull piles and volunteer potatoes, using proper harvesting and storage practices, and applying fungicides when necessary.',
        isSelected: false),
    Plant(
        plantId: 5,
        category: 'Bell Pepper',
        plantName: 'Bacterial Spot',
        size: 'Medium',
        rating: 4.4,
        imageURL: 'assets/images/B_Bacterial_Spot.png',
        isFavorated: false,
        decription:
        'PossibleCauses - Caused by Xanthomonas bacteria, spread through splashing rain.'
        '\n\nPossibleSolution - Spray early and often. Use copper and Mancozeb sprays.',
        isSelected: false),
    Plant(
        plantId: 6,
        category: 'Tomato',
        plantName: 'Leaf Mold',
        size: 'Small',
        rating: 4.2,
        imageURL: 'assets/images/Leaf Mold.png',
        isFavorated: false,
        decription:
        'PossibleCauses - High relative humidity (greater than 85%'
        '\n\nPossibleSolution - Growing leaf mold resistant varieties, use drip irrigation to avoid watering foliage.',
        isSelected: false),
    Plant(
        plantId: 7,
        category: 'Tomato',
        plantName: 'Target Spot',
        size: 'Medium',
        rating: 4.5,
        imageURL: 'assets/images/Target_Spot.png',
        isFavorated: false,
        decription:
        'PossibleCauses - The fungus Corynespora cassiicola which spreads to plants.'
        '\n\nPossibleSolution - Planting resistant varieties, keeping farms free from weeds.',
        isSelected: false),
    Plant(
        plantId: 8,
        category: 'Tomato',
        plantName: 'Mosaic Virus',
        size: 'Medium',
        rating: 4.7,
        imageURL: 'assets/images/Mosaic_Virus.png',
        isFavorated: false,
        decription:
        'PossibleCauses - Spread by aphids and other insects, mites, fungi, nematodes, and contact; pollen and seeds can carry the infection as well.'
        '\n\nPossibleSolution - No cure for infected plants, remove all infected plants and destroy them.',
        isSelected: false),
  ];

  //Get the favorated items
  static List<Plant> getFavoritedPlants(){
    List<Plant> _travelList = Plant.plantList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Plant> addedToCartPlants(){
    List<Plant> _selectedPlants = Plant.plantList;
    return _selectedPlants.where((element) => element.isSelected == true).toList();
  }
}