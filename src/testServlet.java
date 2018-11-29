import com.alibaba.fastjson.JSON;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * @author Erisu
 * @date 2018/10/26 11:35
 * @Description 测试类
 * @Version 1.0
 **/
@WebServlet("/test")
public class testServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String temp=request.getParameter("form");
        String tag=request.getParameter("name");
        System.out.println(temp);
        if(tag.equals("relation")){
            List<String>list=DeUtils.getRelation(temp);
            out.write(JSON.toJSONString(list));  //将数据传到前端
        }else if(tag.equals("entity")){
            List<String>list = DeUtils.getEntity(temp);
            out.write(JSON.toJSONString(list));
        }

        //System.out.println(list);
        response.setContentType("text/xml;charset=UTF-8");
        out.close();

    }
}
