import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/welcome_constants.dart';
import 'dart:async'; // Import para Timer
import '../../../profile/presentation/pages/perfil_intellimen.dart';

class WelcomeHomePage extends StatefulWidget {
  const WelcomeHomePage({super.key});

  @override
  State<WelcomeHomePage> createState() => _WelcomeHomePageState();
}

class _WelcomeHomePageState extends State<WelcomeHomePage> {
  int _selectedTab = 1; // 0: Academy, 1: IntelliMen, 2: Campus
  int _currentBanner = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Usar constantes do WelcomeConstants

  // Controller e timer para o carrossel automático
  final ScrollController _avatarScrollController = ScrollController();
  final PageController _bannerPageController = PageController();
  Timer? _avatarScrollTimer;
  Timer? _bannerScrollTimer;
  bool _isAvatarHovered = false;

  // Lista de banners
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'ACEITE O DESAFIO',
      'subtitle': 'CLIQUE AQUI PARA LER O MANIFESTO E PARTICIPE!',
      'image': WelcomeConstants.bannerImage,
    },
    {
      'title': 'COMUNIDADE INTELIMEN',
      'subtitle': 'CONECTE-SE COM OUTROS HOMENS INTELIGENTES',
      'image': WelcomeConstants.bannerImage,
    },
    {
      'title': 'DESENVOLVIMENTO PESSOAL',
      'subtitle': 'CRESÇA JUNTO COM NOSSA COMUNIDADE',
      'image': WelcomeConstants.bannerImage,
    },
    {
      'title': 'LIDERANÇA E PROPÓSITO',
      'subtitle': 'DESCUBRA SEU VERDADEIRO POTENCIAL',
      'image': WelcomeConstants.bannerImage,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAvatarAutoScroll();
    _startBannerAutoScroll();
  }

  void _startAvatarAutoScroll() {
    _avatarScrollTimer?.cancel();
    _avatarScrollTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (_avatarScrollController.hasClients) {
        final maxScroll = _avatarScrollController.position.maxScrollExtent;
        final current = _avatarScrollController.offset;
        double next = current + 1.0;
        if (next >= maxScroll) {
          // Volta para o início suavemente
          _avatarScrollController.jumpTo(0);
        } else {
          _avatarScrollController.jumpTo(next);
        }
      }
    });
  }

  void _startBannerAutoScroll() {
    _bannerScrollTimer?.cancel();
    _bannerScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_bannerPageController.hasClients) {
        final nextPage = (_currentBanner + 1) % _banners.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentBanner = nextPage;
        });
      }
    });
  }

  // Pausar e retomar o carrossel
  void _pauseAvatarAutoScroll() {
    if (!_isAvatarHovered) {
      _isAvatarHovered = true;
      _avatarScrollTimer?.cancel();
    }
  }
  void _resumeAvatarAutoScroll() {
    if (_isAvatarHovered) {
      _isAvatarHovered = false;
      _startAvatarAutoScroll();
    }
  }

  @override
  void dispose() {
    _avatarScrollTimer?.cancel();
    _bannerScrollTimer?.cancel();
    _avatarScrollController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  Widget _buildStatusBarBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).padding.top,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            _buildStatusBarBackground(context),
            _buildBackgroundImage(),
            _buildMainContent(),
            _buildBottomNavigation(),
            _buildLoadingOverlay(),
          ],
        ),
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
      child: MouseRegion(
        onEnter: (_) => _pauseAvatarAutoScroll(),
        onExit: (_) => _resumeAvatarAutoScroll(),
        child: SizedBox(
          height: WelcomeConstants.avatarRadius * 2 + 16 + 15, // 80 + 10(top) + 5(bottom)
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Fundo preenchendo toda a área entre as linhas
              Container(
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
              ),
              _buildGradientLine(Alignment.topCenter),
              Align(
                alignment: Alignment.center,
                child: ListView.builder(
                  controller: _avatarScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: 10000, // Repete infinitamente
                  itemBuilder: (context, index) => _buildAvatarItem(index % WelcomeConstants.avatarUrls.length),
                ),
              ),
              _buildGradientLine(Alignment.bottomCenter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientLine(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        height: 2, // Espessura reduzida para 2px
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
    return const SizedBox.shrink();
  }

  Widget _buildAvatarItem(int index) {
    return MouseRegion(
      onEnter: (_) => _pauseAvatarAutoScroll(),
      onExit: (_) => _resumeAvatarAutoScroll(),
      child: Container(
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
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Linha sólida 1px abaixo das tabs
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 1), // Espaço de 1px
              Container(
                height: 1,
                color: const Color(0xFFD81B60),
              ),
            ],
          ),
        ),
        // As tabs
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      flex: i == 1 ? 6 : 4,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: i == 1 ? 22 : 10,
                          bottom: 0,
                          left: i == 0 ? 8 : 3,
                          right: i == 2 ? 8 : 3,
                        ),
                        child: _buildTabButton(i),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Não precisa mais do gradiente para a linha das tabs
  Widget _buildTabGradientLine() {
    return const SizedBox.shrink();
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
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: GestureDetector(
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
                fontSize: index == 1 ? 20 : 16, // INTELLIMEN maior
                letterSpacing: 2,
              ),
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
      padding: const EdgeInsets.fromLTRB(16, 3, 16, 1), // 5px em cima (3+2), 1px embaixo
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0x80333333), // #333333 com 50% de opacidade
          border: Border.all(color: const Color(0xFF546E7A), width: 1),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(WelcomeConstants.buttonBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
          ),
          onPressed: () => _handleActionButton(),
          child: Text(
            'SAIBA MAIS',
            style: WelcomeConstants.buttonTextStyle,
          ),
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
            _buildBannerPageView(),
            _buildBannerIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerPageView() {
    return PageView.builder(
      controller: _bannerPageController,
      onPageChanged: (index) {
        setState(() {
          _currentBanner = index;
        });
      },
      itemCount: _banners.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Stack(
            children: [
              _buildBannerBackground(index),
              _buildBannerOverlay(),
              _buildBannerContent(index),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerBackground(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WelcomeConstants.bannerBorderRadius),
        image: DecorationImage(
          image: AssetImage(_banners[index]['image']),
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

  Widget _buildBannerContent(int index) {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _banners[index]['title']!,
            style: WelcomeConstants.bannerTitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _banners[index]['subtitle']!,
            style: WelcomeConstants.bannerSubtitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WelcomeConstants.buttonBorderRadius),
              ),
            ),
            onPressed: () => _handleBannerAction(index),
            child: const Text('SAIBA MAIS'),
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
        children: List.generate(_banners.length, (index) => Container(
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
    return GestureDetector(
      onTap: () => _handleNavIconTap(icon),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }

  Widget _buildCentralNavButton() {
    return GestureDetector(
      onTap: () => _handleCentralNavTap(),
      child: Container(
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
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PerfilIntellimenPage(),
          ),
        );
      },
      child: CircleAvatar(
        radius: WelcomeConstants.profileAvatarRadius,
        backgroundImage: NetworkImage(WelcomeConstants.defaultAvatarUrl),
      ),
    );
  }

  // Métodos de ação
  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMenuSheet(),
    );
  }

  Widget _buildMenuSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF232323),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildMenuItem(Icons.person, 'Perfil', () => _handleProfileTap()),
          _buildMenuItem(Icons.settings, 'Configurações', () => _handleSettingsTap()),
          _buildMenuItem(Icons.help, 'Ajuda', () => _handleHelpTap()),
          _buildMenuItem(Icons.info, 'Sobre', () => _handleAboutTap()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _handleSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrindo configurações...')),
    );
  }

  void _handleHelpTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrindo ajuda...')),
    );
  }

  void _handleAboutTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrindo informações sobre o app...')),
    );
  }

  void _handleActionButton() {
    // Abre a tela de detalhes de acordo com a aba
    setState(() {
      _isLoading = true;
    });
    
    // Simular carregamento
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
      
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
    });
  }

  Widget _buildLoadingOverlay() {
    if (!_isLoading) return const SizedBox.shrink();
    
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Limpar erro após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  void _handleNetworkError() {
    _showError('Erro de conexão. Verifique sua internet.');
  }

  void _handleGeneralError() {
    _showError('Algo deu errado. Tente novamente.');
  }

  void _handleBannerAction(int index) {
    // Implementar ação do banner
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrindo manifesto ${_banners[index]['title']}...')),
    );
  }

  // Métodos de navegação
  void _handleNavIconTap(IconData icon) {
    switch (icon) {
      case Icons.home:
        // Se já estiver na home, apenas faz pop até a primeira tela
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        break;
      case Icons.search:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Abrindo busca...')),
        );
        break;
      case Icons.ondemand_video:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Abrindo vídeos...')),
        );
        break;
    }
  }

  void _handleCentralNavTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Criando novo conteúdo...')),
    );
  }

  void _handleProfileTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrindo perfil...')),
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