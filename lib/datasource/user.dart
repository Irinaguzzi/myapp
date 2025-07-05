// aca defino la clase user y la lista de usuarios validos para login
class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

final List<User> users = [
  User(username: 'ale.profe.dap', password: '1234567'),
  User(username: 'yo.iru', password: '07012008'),
  User(username: 'chichamilanesa', password: '19.11'),
  User(username: 'midni', password: '48447514'),
  User(username: 'abecedario', password: 'abcdefghijklmnñopqrstuvwxyz'),
  User(username: 'listoelpollo', password: 'serie de television'),
];
