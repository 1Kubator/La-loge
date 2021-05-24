enum Role { storeUser, admin }

class RoleHelper {
  static String getValue(Role role) {
    switch (role) {
      case Role.storeUser:
        return 'store_user';
      case Role.admin:
        return 'admin';
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
      default:
        return null;
    }
  }
}
