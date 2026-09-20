//PART A
import 'package:flutter/material.dart'; // for material design widgets
import 'package:project/CA_Assignment1/post.dart'; // for the User model

class UserCard extends StatelessWidget { // stateless widgets card ke liye use hota hai
  final User user;    // user jo card par dikhe 
  final VoidCallback onTap; // jab card par tap kare tou kya hoga
  final VoidCallback onFavoriteToggle; // jab favorite icon par tap kare tou kya hoga

  const UserCard({ // constructor
    super.key, // super key parent constructor ko paas karti hai 
    required this.user, // user object jo card par dikhe
    required this.onTap, // jab card par tap kare tou kya hoga
    required this.onFavoriteToggle, // jab favorite icon par tap kare tou kya hoga
  });

  @override
  Widget build(BuildContext context) { // build method jo widget tree ko return karta hai
    return Card( // card widget jo user ke liye ek card banata hai
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // card ke margin
      child: ListTile( // list tile jo card ke andar content ko arrange karta hai
        onTap: onTap, // jab card par tap kare tou onTap function call hoga
        leading: CircleAvatar( 
          child: Text(user.initials),
        ), // leading widget jo card ke left side par dikhe, yahan par user ke initials ko circle avatar me dikhao
        title: Text( 
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ), // title widget jo card ke center me dikhe, yahan par user ka name dikhao
        subtitle: Text('${user.email} • ${user.company.name}'), // subtitle widget jo card ke neeche dikhe, yahan par user ka email aur company name dikhao
        trailing: IconButton( // trailing widget jo card ke right side par dikhe, yahan par favorite icon dikhao
          icon: Icon(
            user.isFavorite ? Icons.favorite : Icons.favorite_border, // fav tou filled heart nahi tou empty heart
            color: user.isFavorite ? Colors.red : Colors.grey, //fav tou red nahi tou grey
          ),// icon button jo favorite icon ko toggle karta hai
          onPressed: onFavoriteToggle, // jab favorite icon par tap kare tou onFavoriteToggle function call hoga
        ),
      ),
    );
  }
}