// providers/auth_provider.dart

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;
  
  const AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.error,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final TokenService _tokenService;

  AuthNotifier(this._authService, this._tokenService)
      : super(const AuthState()) {
    _checkAuth();  // Verifica se c'è già un token salvato
  }

  Future<void> _checkAuth() async {
    final token = await _tokenService.getAccessToken();
    if (token != null) {
      try {
        final user = await _authService.getCurrentUser();
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } catch (_) {
        await _tokenService.clearTokens();
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }
}