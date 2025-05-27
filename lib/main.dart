import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            color: Colors.amber,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.orange.withOpacity(0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Navigation bar
              Padding(
                padding: const EdgeInsets.only(
                  left: 100.0,
                  right: 100.0,
                  top: 80.0,
                  bottom: 50.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animationController.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Open to work',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        const url = 'https://drive.google.com/your-cv-url';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text('Download CV'),
                    ),
                  ],
                ),
              ),
              // PageView for scrollable sections
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return _buildHomePage(context);
                      case 1:
                        return _buildSummaryPage();
                      case 2:
                        return _buildExperiencePage();
                      case 3:
                        return _buildSkillsPage();
                      case 4:
                        return _buildLinksPage();
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              // Bottom navigation
              Container(
                height: 50,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavButton(
                      Icons.person_outline,
                      'Home',
                      _currentPage == 0,
                      0,
                    ),
                    _buildNavButton(
                      Icons.description_outlined,
                      'Summary',
                      _currentPage == 1,
                      1,
                    ),
                    _buildNavButton(
                      Icons.work_outline,
                      'Experience',
                      _currentPage == 2,
                      2,
                    ),
                    _buildNavButton(
                      Icons.psychology_outlined,
                      'Skills',
                      _currentPage == 3,
                      3,
                    ),
                    _buildNavButton(Icons.link, 'Links', _currentPage == 4, 4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    IconData icon,
    String label,
    bool isSelected,
    int page,
  ) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: 60,
        child: TextButton.icon(
          onPressed: () => _navigateToPage(page),
          icon: Icon(
            icon,
            color: isSelected ? Colors.black : Colors.white54,
            size: 20,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white54,
              fontSize: 14,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? Colors.white : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Fade Effect
        Positioned.fill(
          child: FadeInImage.assetNetwork(
            placeholder:
                'assets/banner.png', // Add a placeholder image in assets
            image: 'assets/banner.png', // Replace with your image path
            fit: BoxFit.cover,
            fadeInDuration: const Duration(seconds: 2),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.only(
            left: 100.0,
            right: 32.0,
            top: 15.0,
            bottom: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOBILE APP DEVELOPER',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Bhavya Sharma',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              Text(
                '4+ years of experience in Mobile App Development\nSpecializing in Android Native (Kotlin) and Flutter (Dart)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              const ContactInfo(
                email: 'your.email@gmail.com',
                phone: '+1 234-567-8900',
                linkedin: 'linkedin.com/in/your-profile',
                location: 'Your City, Country',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 32.0,
        top: 15.0,
        bottom: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'I am an experienced and detail-oriented Mobile App Developer dedicated to '
            'creating intuitive and impactful digital experiences. Over the years, I have '
            'honed my skills in Android Native and Flutter development, always striving to '
            'balance user needs with business objectives. My passion lies in understanding '
            'how people interact with mobile applications and crafting solutions that are '
            'both functional and aesthetically pleasing.',
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.6),
          ),
          const SizedBox(height: 24),
          const Text(
            'I have collaborated with diverse teams, including developers, marketers, and '
            'product managers, to bring concepts to life, ensuring seamless integration of '
            'design and functionality. My development philosophy centers on clean code and '
            'innovation—placing the user at the heart of every decision while leveraging '
            'the latest tools and trends to stay ahead in the field.',
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.6),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.amber, width: 4)),
            ),
            child: Text(
              'Driven by a curiosity to learn and improve, I continuously explore new '
              'tools and methodologies to enhance my work. Whether working on Android '
              'applications, Flutter interfaces, or cross-platform solutions, I am '
              'committed to delivering high-quality results that exceed expectations.',
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperiencePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 100.0,
          right: 32.0,
          top: 15.0,
          bottom: 32.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Work Experience',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 32),
            // Experience Item
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'UX/UI DESIGNER',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '2021 - Present',
                      style: TextStyle(color: Colors.amber, fontSize: 16),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'Creative Solutions Agency',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    'At Creative Solutions Agency, I lead design efforts on a range of high-profile projects, '
                    'focusing on enhancing user experience across multiple platforms, from web to mobile applications. '
                    'I collaborate closely with developers and stakeholders to ensure that design solutions meet both '
                    'user needs and business objectives.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Selected Projects Section
            const Text(
              'Selected Projects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 24),
            // Project Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildProjectCard(
                    'Pixel Pathway',
                    'A dynamic UX/UI design journey',
                    'assets/project1.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProjectCard(
                    'Flowstate',
                    'An innovative design solution',
                    'assets/project2.png',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, String imagePath) {
    return Padding(
      padding: EdgeInsets.only(
        left: 100.0,
        right: 32.0,
        top: 15.0,
        bottom: 32.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black45,
                    // Replace with actual image when available
                    // child: Image.asset(
                    //   imagePath,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.open_in_new,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 100.0,
          right: 32.0,
          top: 15.0,
          bottom: 32.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skills & Tools',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 48),
            // Skills Section
            Wrap(
              spacing: 48,
              runSpacing: 20,
              children: [
                _buildSkillItem('User Research'),
                _buildSkillItem('Interaction Design'),
                _buildSkillItem('Usability Testing'),
                _buildSkillItem('Design Systems'),
                _buildSkillItem('Wireframing/Prototyping'),
                _buildSkillItem('Responsive Web Design'),
                _buildSkillItem('Visual Design'),
              ],
            ),
            const SizedBox(height: 64),
            // Tools Section
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                _buildToolItem('Framer', 'assets/framer.png'),
                _buildToolItem('Figma', 'assets/figma.png'),
                _buildToolItem('Photoshop', 'assets/photoshop.png'),
                _buildToolItem('Illustrator', 'assets/illustrator.png'),
                _buildToolItem('Sketch', 'assets/sketch.png'),
                _buildToolItem('Midjourney', 'assets/midjourney.png'),
                _buildToolItem('Spline', 'assets/spline.png'),
                _buildToolItem('Blender', 'assets/blender.png'),
              ],
            ),
            const SizedBox(height: 64),
            // Languages Section
            const Text(
              'LANGUAGES',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(String skill) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          skill,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildToolItem(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            // Replace with actual image when available
            // child: Image.asset(
            //   imagePath,
            //   width: 40,
            //   height: 40,
            // ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildLinksPage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 32.0,
        top: 15.0,
        bottom: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Links',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 48),
          // Social Media Links
          Wrap(
            spacing: 16,
            children: [
              _buildSocialButton('LinkedIn', Icons.contact_page, Colors.blue),
              _buildSocialButton(
                'Dribbble',
                Icons.sports_basketball,
                const Color(0xFFEA4C89),
              ),
              _buildSocialButton('Twitter', Icons.flutter_dash, Colors.black),
              _buildSocialButton('Instagram', Icons.camera_alt, Colors.purple),
              _buildSocialButton('Behance', Icons.brush, Colors.black),
            ],
          ),
          const SizedBox(height: 64),
          // Contact Information
          Row(
            children: [
              _buildContactLink(
                Icons.email,
                'your.email@gmail.com',
                Colors.amber,
              ),
              const SizedBox(width: 32),
              _buildContactLink(Icons.phone, '+1 234-567-8900', Colors.amber),
            ],
          ),
          const Spacer(),
          // Footer
          const Text(
            '© 2025 Portfolio template by Your Name',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String name, IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 28,
        onPressed: () {
          // Add your social media link handling here
        },
      ),
    );
  }

  Widget _buildContactLink(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  final String email;
  final String phone;
  final String linkedin;
  final String location;

  const ContactInfo({
    super.key,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildContactRow(Icons.email, email),
            const SizedBox(width: 70),
            _buildContactRow(Icons.phone, phone),
          ],
        ),

        const SizedBox(height: 25),
        Row(
          children: [
            _buildContactRow(Icons.contact_page, linkedin),
            const SizedBox(width: 40),
            _buildContactRow(Icons.location_on, location),
          ],
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
