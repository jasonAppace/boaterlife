import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _loadingProgress = 0.0;

  static const String gameUrl = 'https://html5.gamemonetize.co/z5khf2ue1xsf7y5wflamr8golmbcoino/';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
              _loadingProgress = 0.0;
            });
          },
          onPageFinished: (String url) {
            // Add a longer delay to ensure all game assets are fully loaded
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Only show error for main resource failures, not sub-resources
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.timeout ||
                error.errorType == WebResourceErrorType.connect) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = 'Unable to load game. Please check your internet connection.';
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all game-related URLs and resources
            return NavigationDecision.navigate;
          },
        ),
      );

    // Load the game with optimized settings
    _loadGame();
  }

  void _loadGame() async {
    try {
      await _controller.loadRequest(
        Uri.parse(gameUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Mobile Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load game';
      });
    }
  }

  void _reloadGame() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _loadingProgress = 0.0;
    });
    _loadGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Game',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadGame,
            tooltip: 'Reload Game',
          ),
          // Invisible widget to center the title properly
          const SizedBox(width: 48),
        ],
      ),
      body: Stack(
        children: [
          // Game WebView Container
          if (!_hasError)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: _isLoading
                  ? Container(color: Colors.white) // White background while loading
                  : ClipRect(
                child: WebViewWidget(controller: _controller),
              ),
            ),

          // Optimized Loading Indicator
          if (_isLoading && !_hasError)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Game controller icon for better UX
                    Icon(
                      Icons.sports_esports,
                      size: 64,
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                    ),
                    const SizedBox(height: 24),

                    // Progress indicator
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: _loadingProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Loading Game...',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      '${(_loadingProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Error State
          if (_hasError)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_esports_outlined,
                        color: Colors.grey[400],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Game Unavailable',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _reloadGame,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }}