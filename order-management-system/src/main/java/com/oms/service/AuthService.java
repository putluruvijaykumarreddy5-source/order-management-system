package com.oms.service;

import com.oms.util.DBConnection;
import java.sql.*;

public class AuthService {
    public boolean authenticate(String username, String password) throws SQLException {
        String sql = "SELECT 1 FROM app_users WHERE username=? AND password=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
