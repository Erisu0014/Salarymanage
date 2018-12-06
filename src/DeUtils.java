import com.bean.Mybean.EntityName;

import java.rmi.Naming;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Erisu
 * @date 2018/10/26 11:02
 * @Description JDBC连接与mysql数据库
 * @Version 1.0
 **/
public class DeUtils {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = null;
            try {
                con = DriverManager.getConnection(
                        "jdbc:mysql://123.56.8.150:3306/salarymanage?useUnicode=true&characterEncoding=UTF-8",
                        "root", "ysu2018");
            } catch (SQLException e) {
                e.printStackTrace();
                return null;
            }
            return con;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) throws SQLException {
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (conn != null) {
            conn.close();
        }

    }

    public static List<String> getEntity(String name) {
        Connection conn = getConnection();
        String sql = "select name from entity where name like '%" + name + "%'";
        PreparedStatement ps = null;
        ResultSet resultSet = null;
        List<String> list = new ArrayList<>();
        try {
            ps = conn.prepareStatement(sql);
            resultSet = ps.executeQuery();

            while (resultSet.next()) {
                list.add(resultSet.getString("name"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            close(conn, ps, resultSet);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;


    }

    public static List<String> getRelation(String name) {
        Connection conn = getConnection();
        String sql = "select name from relation where name like '%" + name + "%'";
        PreparedStatement ps = null;
        ResultSet resultSet = null;
        List<String> list = new ArrayList<>();
        try {
            ps = conn.prepareStatement(sql);
            resultSet = ps.executeQuery();

            while (resultSet.next()) {
                list.add(resultSet.getString("name"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            close(conn, ps, resultSet);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /*
    查询单实体
     */
    public static EntityName getOneEntity(String name) {
        Connection conn = getConnection();
        System.out.println(name);
        String sql = "select * from entity where name =?";
        PreparedStatement ps = null;
        ResultSet resultSet = null;
        List<String> list = new ArrayList<>();
        EntityName entity = new EntityName();
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            resultSet = ps.executeQuery();
            while (resultSet.next()) {
                entity.setName(resultSet.getString("name"));
                entity.setDefine(resultSet.getString("define"));
                entity.setSentence(resultSet.getString("sentence"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            close(conn, ps, resultSet);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return entity;
    }

}
