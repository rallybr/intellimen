import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/welcome_constants.dart';

class WelcomeHomePage extends StatefulWidget {
  const WelcomeHomePage({super.key});

  @override
  State<WelcomeHomePage> createState() => _WelcomeHomePageState();
}

class _WelcomeHomePageState extends State<WelcomeHomePage> {
  int _selectedTab = 1; // 0: Academy, 1: IntelliMen, 2: Campus
  int _currentBanner = 0;

  // Usar constantes do WelcomeConstants

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildMainContent(),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        WelcomeConstants.backgroundImage,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90),
      child: Column(
        children: [
          _buildHeader(),
          _buildAvatarCarousel(),
          _buildTabNavigation(),
          _buildContentCard(),
          _buildBannerSlider(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
              child: Container(
          color: Colors.black,
          padding: WelcomeConstants.headerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    WelcomeConstants.logoImage,
                    height: WelcomeConstants.headerHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 32),
              onPressed: () => _showMenuOptions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        height: WelcomeConstants.avatarRadius * 2 + WelcomeConstants.gradientLineHeight * 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildGradientLine(Alignment.topCenter),
            _buildAvatarContainer(),
            _buildGradientLine(Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientLine(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        height: WelcomeConstants.gradientLineHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: WelcomeConstants.gradientColors,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarContainer() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: WelcomeConstants.avatarRadius * 2 + 16, // 80
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF333333),
              Color(0xFF434343),
              Color(0xFF333333),
            ],
          ),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          itemCount: WelcomeConstants.avatarUrls.length,
          itemBuilder: (context, index) => _buildAvatarItem(index),
        ),
      ),
    );
  }

  Widget _buildAvatarItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: CircleAvatar(
        radius: WelcomeConstants.avatarRadius,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: WelcomeConstants.avatarInnerRadius,
          backgroundColor: const Color(0xFFE3F6FF),
          backgroundImage: NetworkImage(WelcomeConstants.avatarUrls[index]),
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildTabGradientLine(),
        _buildTabButtons(),
      ],
    );
  }

  Widget _buildTabGradientLine() {
    return Container(
      height: WelcomeConstants.tabGradientHeight,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: WelcomeConstants.gradientColors,
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 0; i < 3; i++)
          Expanded(
            flex: i == 1 ? 6 : 4,
            child: Padding(
              padding: EdgeInsets.only(
                top: i == 1 ? 22 : 10,
                bottom: 10,
                left: 8,
                right: 8,
              ),
              child: _buildTabButton(i),
            ),
          ),
      ],
    );
  }

  Widget _buildTabButton(int index) {
    final isSelected = _selectedTab == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: index == 1 ? 20 : 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? null
              : LinearGradient(
                  colors: WelcomeConstants.tabGradients[index],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isSelected ? const Color(0xFFE5F7FF) : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(index == 0 ? WelcomeConstants.tabBorderRadius : WelcomeConstants.tabBorderRadius),
            topRight: Radius.circular(index == 2 ? WelcomeConstants.tabBorderRadius : WelcomeConstants.tabBorderRadius),
            bottomLeft: const Radius.circular(0),
            bottomRight: const Radius.circular(0),
          ),
          boxShadow: isSelected ? WelcomeConstants.tabShadow : [],
        ),
        child: Center(
          child: Text(
            WelcomeConstants.tabLabels[index],
            style: TextStyle(
              color: isSelected ? const Color(0xFF232323) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: index == 1 ? 15 : 16,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  // Resumos para os cards principais
  static const String _resumoAcademy =
      'O Academy é a área de formação avançada do projeto, voltada para quem deseja se aprofundar em temas de liderança, propósito e desenvolvimento pessoal. Aqui você encontra conteúdos exclusivos, desafios especiais e acompanhamento.';
  static const String _resumoIntellimen =
      'Você já deve ter sacado que o nome do projeto é uma junção das palavras em inglês intelligent (inteligentes) e men (homens). Escolhemos esse nome porque além de soar como um super-herói, que todo homem secretamente aspira ser...';
  static const String _resumoCampus =
      'O Campus é o espaço para jovens entre 17 e 25 anos que querem crescer juntos, trocar experiências e participar de atividades presenciais e online. Aqui você encontra uma comunidade vibrante, eventos, grupos de estudo.';

  Widget _buildContentCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0x80333333), // #333333 com 50% de opacidade
          border: Border.all(color: const Color(0xFFFFA726), width: 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(42),
            bottomRight: Radius.circular(42),
          ),
          boxShadow: WelcomeConstants.cardShadow,
        ),
        child: Padding(
          padding: WelcomeConstants.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildContentTitleWhite(),
              const SizedBox(height: 20),
              _buildContentDescriptionResumo(),
              const SizedBox(height: 18),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentTitleWhite() {
    final title = WelcomeConstants.tabContents[_selectedTab]['title']!;
    final isIntelliMen = _selectedTab == 1;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: isIntelliMen ? title.split('IntelliMen')[0] : title,
            style: WelcomeConstants.titleStyle.copyWith(color: Colors.white),
          ),
          if (isIntelliMen)
            TextSpan(
              text: 'IntelliMen',
              style: WelcomeConstants.titleBoldStyle.copyWith(color: Colors.white),
            ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentDescriptionWhite() {
    return Text(
      WelcomeConstants.tabContents[_selectedTab]['desc']!,
      style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentDescriptionResumo() {
    // Mostra o resumo de acordo com a aba selecionada
    if (_selectedTab == 0) {
      return Text(
        _resumoAcademy,
        style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      );
    } else if (_selectedTab == 1) {
      return Text(
        _resumoIntellimen,
        style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      );
    } else if (_selectedTab == 2) {
      return Text(
        _resumoCampus,
        style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      );
    } else {
      return _buildContentDescriptionWhite();
    }
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WelcomeConstants.buttonBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: () => _handleActionButton(),
        child: Text(
          'SAIBA MAIS',
          style: WelcomeConstants.buttonTextStyle,
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Padding(
      padding: WelcomeConstants.bannerPadding,
      child: SizedBox(
        height: WelcomeConstants.bannerHeight,
        child: Stack(
          children: [
            _buildBannerBackground(),
            _buildBannerOverlay(),
            _buildBannerContent(),
            _buildBannerIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WelcomeConstants.bannerBorderRadius),
        image: const DecorationImage(
          image: AssetImage(WelcomeConstants.bannerImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBannerOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WelcomeConstants.bannerBorderRadius),
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }

  Widget _buildBannerContent() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ACEITE O DESAFIO',
            style: WelcomeConstants.bannerTitleStyle,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WelcomeConstants.buttonBorderRadius),
              ),
            ),
            onPressed: () => _handleBannerAction(),
            child: const Text('CLIQUE AQUI PARA LER O MANIFESTO E PARTICIPE!'),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentBanner == index ? Colors.pinkAccent : Colors.white24,
            shape: BoxShape.circle,
          ),
        )),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: WelcomeConstants.bottomNavHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: WelcomeConstants.bottomNavShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
              _buildNavIcon(Icons.home, WelcomeConstants.navIconColors[0]),
              _buildNavIcon(Icons.search, WelcomeConstants.navIconColors[1]),
              _buildCentralNavButton(),
              _buildNavIcon(Icons.ondemand_video, WelcomeConstants.navIconColors[2]),
              _buildProfileAvatar(),
            ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 32);
  }

  Widget _buildCentralNavButton() {
    return Container(
      height: WelcomeConstants.centralNavButtonSize,
      width: WelcomeConstants.centralNavButtonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF232343), width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.add, color: Color(0xFF232343), size: 38),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: WelcomeConstants.profileAvatarRadius,
      backgroundImage: NetworkImage(WelcomeConstants.defaultAvatarUrl),
    );
  }

  // Métodos de ação
  void _showMenuOptions() {
    // Implementar menu de opções
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu de opções em desenvolvimento')),
    );
  }

  void _handleActionButton() {
    // Abre a tela de detalhes de acordo com a aba
    if (_selectedTab == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const _AcademyDetailPage(),
        ),
      );
    } else if (_selectedTab == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const _IntellimenDetailPage(),
        ),
      );
    } else if (_selectedTab == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const _CampusDetailPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navegando para mais informações...')),
      );
    }
  }

  void _handleBannerAction() {
    // Implementar ação do banner
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrindo manifesto...')),
    );
  }
} 

// Nova tela de detalhes para Academy
class _AcademyDetailPage extends StatelessWidget {
  const _AcademyDetailPage({Key? key}) : super(key: key);

  static const String _textoCompleto =
      'O Academy é a área de formação avançada do projeto, voltada para quem deseja se aprofundar em temas de liderança, propósito e desenvolvimento pessoal. Aqui você encontra conteúdos exclusivos, desafios especiais e acompanhamento de mentores.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'O que é o Academy?',
                  style: WelcomeConstants.titleBoldStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  _textoCompleto,
                  style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 

// Nova tela de detalhes para Campus
class _CampusDetailPage extends StatelessWidget {
  const _CampusDetailPage({Key? key}) : super(key: key);

  static const String _textoCompleto =
      'O Campus é o espaço para jovens entre 17 e 25 anos que querem crescer juntos, trocar experiências e participar de atividades presenciais e online. Aqui você encontra uma comunidade vibrante, eventos, grupos de estudo e muito mais. Venha fazer parte dessa jornada!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'O que é o Campus?',
                  style: WelcomeConstants.titleBoldStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  _textoCompleto,
                  style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 

// Nova tela de detalhes para IntelliMen
class _IntellimenDetailPage extends StatelessWidget {
  const _IntellimenDetailPage({Key? key}) : super(key: key);

  static const String _textoCompleto =
      'Você já deve ter sacado que o nome do projeto é uma junção das palavras em inglês intelligent (inteligentes) e men (homens). Escolhemos esse nome porque além de soar como um super-herói, que todo homem secretamente aspira ser desde criança, ele engloba tudo o que o projeto aspira: formar homens inteligentes e melhores em tudo. Não prometemos superpoderes como levantar ônibus com um dedo, voar ou invisibilidade — mas estamos trabalhando nisso.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'O que é O Intellimen?',
                  style: WelcomeConstants.titleBoldStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  _textoCompleto,
                  style: WelcomeConstants.descriptionStyle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 