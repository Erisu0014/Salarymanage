

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;

@WebServlet("/Showall")
public class Showall extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public Showall() {
		super();
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		String authorizationhead="neo4j:123456nba";
		String s=null;
		byte[] by = null;
		URL url = new URL("http://47.92.155.245:7474/db/data/transaction/commit");
		try {
			by = authorizationhead.getBytes("utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		if (by != null) {
			s="Basic "+Base64.encodeBase64String(by);
		}
		HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
		httpURLConnection.setRequestMethod("POST");
		httpURLConnection.setRequestProperty("Accept", "application/json;charset=UTF-8");
		httpURLConnection.setRequestProperty("Authorization",s);
		httpURLConnection.setRequestProperty("Content-type","application/json");
		httpURLConnection.setDoOutput(true);
		httpURLConnection.setDoInput(true);
		OutputStream outputStream = httpURLConnection.getOutputStream();
		String query="{\"statements\":[{\"statement\":\" match (n) optional match (n)-[r]-() return n,r\",\"resultDataContents\":[\"graph\"]}]}";
		outputStream.write(query.getBytes("utf-8"));
		InputStream in = httpURLConnection.getInputStream();
		InputStreamReader isr = new InputStreamReader(in,"UTF-8");
		String results = "";
        /*int tmp;
        while((tmp = isr.read()) != -1){
            results += (char)tmp;
        } */
		BufferedReader br=new BufferedReader(isr);
		String line;
		while((line=br.readLine()) != null){
			results+=line;
		}
		out.println(results);
	}

}
