import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details extends StatefulWidget {
  String name, image, description, price;
  Details({super.key, required this.description, required this.image, required this.price, required this.name});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  double _rating = 0;
  String id = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> reviews = [];
  bool isSubmitting = false;
  double productRating = 0;
  int totalRatings = 0;
  
  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _fetchProductRating();
  }
  
  Future<void> _fetchProductRating() async {
    try {
      DocumentSnapshot productDoc = await _firestore
          .collection('products')
          .doc(widget.name)
          .get();
          
      if (productDoc.exists) {
        Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;
        setState(() {
          productRating = data['avgRating'] ?? 0;
          totalRatings = data['totalRatings'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching product rating: $e');
    }
  }
  
  Future<void> _fetchReviews() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .doc(widget.name)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .get();
          
      setState(() {
        reviews = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }
  
  Future<void> _submitReview() async {
    if (_rating == 0 || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add both rating and comment'))
      );
      return;
    }
    
    setState(() {
      isSubmitting = true;
    });
    
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(id)
          .get();
      String userName = userDoc.exists ? (userDoc.data() as Map<String, dynamic>)['username'] ?? 'Anonymous' : 'Anonymous';
      
      Map<String, dynamic> reviewData = {
        'userId': id,
        'userName': userName,
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'timestamp': Timestamp.now(),
      };
      
      await _firestore
          .collection('products')
          .doc(widget.name)
          .collection('reviews')
          .add(reviewData);
      
      // Update product average rating
      DocumentSnapshot productDoc = await _firestore
          .collection('products')
          .doc(widget.name)
          .get();
      
      if (productDoc.exists) {
        Map<String, dynamic> productData = productDoc.data() as Map<String, dynamic>;
        double currentAvgRating = productData['avgRating'] ?? 0;
        int totalRatings = productData['totalRatings'] ?? 0;
        
        double newAvgRating = ((currentAvgRating * totalRatings) + _rating) / (totalRatings + 1);
        
        await _firestore
            .collection('products')
            .doc(widget.name)
            .set({
              'avgRating': newAvgRating,
              'totalRatings': totalRatings + 1
            }, SetOptions(merge: true));
            
        setState(() {
          productRating = newAvgRating;
          this.totalRatings = totalRatings + 1;
        });
      }
      
      // Reset form and refresh reviews
      setState(() {
        _rating = 0;
        _commentController.clear();
        isSubmitting = false;
      });
      
      await _fetchReviews();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!'))
      );
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e'))
      );
    }
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  child: Image.network(
                    widget.image,
                    height: MediaQuery.of(context).size.height / 2.4,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitHeight,
                  )
                ),
                const SizedBox(height: 20),
                
                // Product Rating Display at the top
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: productRating,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 255, 174, 0),
                      ),
                      itemCount: 5,
                      itemSize: 24,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      productRating > 0 
                          ? '${productRating.toStringAsFixed(1)} (${totalRatings} ${totalRatings == 1 ? 'review' : 'reviews'})' 
                          : 'No reviews yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                Text(widget.name, style: AppWidget.HeadTextStyle()),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.description,
                    style: AppWidget.LightTextStyle().copyWith(fontSize: 18),
                  )
                ),
                const SizedBox(height: 30),
                
                // Review Section
                Text("Write a Review", style: AppWidget.HeadTextStyle()),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 255, 174, 0),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  }
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _commentController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Share your experience with this product...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white70)
                      : const Text(
                          "Submit Review",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                ),
                const SizedBox(height: 30),
                
                // Reviews List
                Text("Customer Reviews", style: AppWidget.HeadTextStyle()),
                const SizedBox(height: 15),
                reviews.isEmpty
                    ? const Center(
                        child: Text(
                          "No reviews yet. Be the first to review!",
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      reviews[index]['userName'] ?? 'Anonymous',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          reviews[index]['rating'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Color.fromARGB(255, 255, 174, 0),
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(reviews[index]['comment'] ?? ''),
                                const SizedBox(height: 5),
                                Text(
                                  _formatTimestamp(reviews[index]['timestamp']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                // Add extra space at bottom for the fixed position cart button
                const SizedBox(height: 100),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 27, top: 10),
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: AppWidget.LightTextStyle().copyWith(fontSize: 26),
                            ),
                            Text(
                              'Rs. ${widget.price}',
                              style: AppWidget.HeadTextStyle(),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2.1,
                            child: GestureDetector(
                              onTap: () async {
                                Map<String, dynamic> addToCart = {
                                  'Name': widget.name,
                                  'Price': widget.price,
                                  'Image': widget.image,
                                  'Description': widget.description,
                                };
                                await DatabaseMethods().addToCart(addToCart, id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Item added to cart!'))
                                );
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'add to cart',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white70,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    DateTime dateTime = timestamp.toDate();
    
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}