final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = /* check auth state */;
    if (!isLoggedIn && state.matchedLocation != '/login') return '/login';
    if (isLoggedIn && state.matchedLocation == '/login') return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/notes/:id', builder: (_, state) => 
      NoteDetailScreen(id: state.pathParameters['id']!)),
  ],
);