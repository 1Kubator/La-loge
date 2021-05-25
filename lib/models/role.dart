enum Role { storeUser, admin, user }

class RoleHelper {
  static String getValue(Role role) {
    switch (role) {
      case Role.storeUser:
        return 'store_user';
      case Role.admin:
        return 'admin';
      case Role.user:
        return 'user';
      default:
        return null;
    }
  }

  static Role fromString(String role) {
    switch (role) {
      case 'store_user':
        return Role.storeUser;
      case 'admin':
        return Role.admin;
      case 'user':
        return Role.user;
      default:
        return null;
    }
  }
}
