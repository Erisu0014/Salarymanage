

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bean.Mybean.EntityName;

@WebServlet("/Getname")
public class Getname extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public Getname() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");		
	    response.setCharacterEncoding("utf-8");	
	    String Name = request.getParameter("name");
	    String name = new String(Name.getBytes("ISO-8859-1"),"utf-8");	   
	    RequestDispatcher dispatcher=null;
	    EntityName entityName=DeUtils.getOneEntity(name);
	    EntityName Ename=new EntityName();
	    Ename.setName(name);
	    request.setAttribute("Ename", Ename);
	    request.setAttribute("entityName",entityName);
    	dispatcher=request.getRequestDispatcher("showdetail.jsp");	
		dispatcher.forward(request,response);
	}

}
