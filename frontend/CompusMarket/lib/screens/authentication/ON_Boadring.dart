
// ignore: file_names
//import 'package:compusmarket/screens/authentication/ON_Boadring2.dart';
import 'package:compusmarket/screens/authentication/sign_in.dart';
import 'package:compusmarket/screens/authentication/sign_up.dart';
import 'package:compusmarket/widgets/standard_Button.dart';
import 'package:flutter/material.dart';



class OnBoadringScreen extends StatefulWidget{
  const OnBoadringScreen({super.key});

  @override
  State<OnBoadringScreen> createState() => _OnBoadringScreenState();
  }

   class _OnBoadringScreenState extends State<OnBoadringScreen>with TickerProviderStateMixin {
    final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;


final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/start_pic1.jpg',
      'title': 'Buy & Sell with Ease',
      'subtitle': 'Post items or discover great deals from\nstudents around you',
    },
    {
      'image': 'assets/images/start_pic2.jpg',
      'title': 'Confidence & Secure',
      'subtitle':
          'Discover verified listings from students\nand connect securely to find what you need',
    },
    {
      'image': 'assets/images/start_pic3.jpg',
      'title': 'Chat, Meet Up, Done!',
      'subtitle':
          'Use the in-app chat to arrange a safe and\nconvenient meet-up place on campus',
    },
  ];

   @override
  void initState() {
    super.initState();
    _setupAnimation();
    _animController.forward();
  }

  void _setupAnimation() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

     _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

     _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
  }

   @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _animController.reset();   // reset to start
    _animController.forward(); // play slide-up again
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

     @override
     Widget build(BuildContext context) {
       final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
   return Scaffold(
    body: Stack(children: [
   PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_pages[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // ── 2. Gradient overlay ──────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: IgnorePointer(
              child: Container(
                height: screenHeight * 0.75,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.97),
                      Colors.black.withOpacity(0.80),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Animated content (slide up + fade in) ─────────────
          Positioned(
            bottom: 70, right: 20, left: 20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [

                    // Title
                    Text(
                      _pages[_currentPage]['title']!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: screenWidth * 0.07,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Subtitle
                    Text(
                      _pages[_currentPage]['subtitle']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.8,
                        fontFamily: 'Inter',
                        fontSize: screenWidth * 0.035,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // ── Animated dots ────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (index) {
                        final isActive = _currentPage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
                          height: screenHeight * 0.01,
                          // Active dot is wider
                          width: isActive
                              ? screenWidth * 0.06
                              : screenWidth * 0.02,
                          decoration: BoxDecoration(
                            // Active dot is blue
                            color: isActive
                                ? const Color(0xff2853af)
                                : const Color(0xffc1c7cf),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // ── Button (Continue or Get Started) ─────────────
                    StandardButton(
                      text: _currentPage < 2 ? "Continue" : "Get Started",
                      onPressed: _currentPage < 2
                          ? _nextPage
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignInScreen()),
                              ),
                    ),

                    // ── Register row (only on last page) ─────────────
                    if (_currentPage == 2) ...[
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'Inter',
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignUpScreen()),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: const Color(0xff2853af),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
   
    ],),
      );

     }
    
   }