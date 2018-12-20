package com.data.manager.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.data.manager.entity.Label;
import com.data.manager.util.PythonCaller;

import ch.ethz.ssh2.Connection;
import net.sf.json.JSONObject;

/**
 * Servlet implementation class ControllerServlet
 */
@WebServlet("/ControllerServlet")
public class ControllerServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private final String IP_ADDRESS = "192.168.247.1";
	private final int PORT = 2222;
	private final String USER_NAME = "koudes2018";
	private final String PASSWORD = "huang2012";
	
	private final String METHOD_LOGIN = "login";
	
	private final String METHOD_REGISTER = "register";
	
	private final String METHOD_TRAIN = "train";
	
	private final String METHOD_DEMOGRAPHIC = "demographic";
	
	private final String METHOD_CONTENT_BASED = "contentBased";
	
	private final String ITEM_BASED_COLLABORATIVE = "itemBasedCollaborative";

	private final String USER_BASED_COLLABORATIVE = "userBasedCollaborative";
	
	private final String CMD_EXECUTE = "cd /mnt/c/Users/JAMES/PycharmProjects/pythonPro2; python3 ";
	
	private final String FILE_PATH = "C:\\Users\\JAMES\\PycharmProjects\\pythonPro2\\ml-100k\\";
	
	private final String FILE_MOVIES = "u.item";
	
	private final String FILE_RATINGS = "u.data";
	
	private final String FILE_RESULTS = "u.result";
	
	
    /**
     * Default constructor. 
     */
    public ControllerServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String method = request.getParameter("method");
		
		// login logic
		if (METHOD_LOGIN.equals(method)) {
			String userName = request.getParameter("userName");
			String password = request.getParameter("password");
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE 
						+ "login.py" 
						+ " " + userName 
						+ " " + password;
				PythonCaller.execute(conn, cmd);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			List<Label> userInfo = PythonCaller.getMovieList(FILE_PATH + FILE_RESULTS, new int[]{0,1});
			
			if (userInfo.size() > 0) {
				List<Label> movieList = PythonCaller.getMovieList(FILE_PATH + FILE_MOVIES, new int[]{0,1});
				PythonCaller.checkMovies(FILE_PATH + FILE_RATINGS, new int[]{0,1}, movieList, userInfo.get(0).getKey());
				request.setAttribute("movieList", movieList);
				request.getSession().setAttribute("userId", userInfo.get(0).getKey());
				request.getSession().setAttribute("userName", userName);
				request.getSession().setAttribute("preference", userInfo.get(0).getValue());
				request.getRequestDispatcher("main.jsp").forward(request, response);
			} else {
				request.setAttribute("errorFlg", true);
				request.getRequestDispatcher("login.jsp").forward(request, response);
			}
			
		} else if (METHOD_REGISTER.equals(method)) {
			// register logic
			
			String userName = request.getParameter("userName");
			String age = request.getParameter("age");
			String sex = request.getParameter("sex");
			String occupation = request.getParameter("occupation");
			String zipCode = request.getParameter("zipCode");
			String password = request.getParameter("password");
			
			String returnString = "";
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE
						+ "register.py" 
						+ " " + age 
						+ " " + sex 
						+ " " + occupation 
						+ " " + zipCode 
						+ " " + userName 
						+ " " + password;
				returnString = PythonCaller.execute(conn, cmd);
				returnString = returnString.replace("\n", "");
			}catch(Exception e){
				e.printStackTrace();
			}
			
			List<Label> movieList = PythonCaller.getMovieList(FILE_PATH + FILE_MOVIES, new int[]{0,1});
			request.setAttribute("movieList", movieList);
			request.getSession().setAttribute("userId", returnString);
			request.getSession().setAttribute("userName", userName);
			request.getSession().setAttribute("preference", "");
			request.getRequestDispatcher("main.jsp").forward(request, response);
			
		} else if (METHOD_TRAIN.equals(method)) {
			// train logic

			String userId = request.getSession().getAttribute("userId").toString();
			String movies = request.getParameter("movies");
			String rating = request.getParameter("rating");
			String recommendUserId = request.getParameter("recommendUserId");
			if (StringUtils.isEmpty(recommendUserId)) {
				recommendUserId = "NULL";
			}
			
			String appId ="111";
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE 
						+ "train.py"
						+ " " + userId 
						+ " " + movies.substring(1, movies.length()) 
						+ " " + rating
						+ " " + recommendUserId;
				PythonCaller.execute(conn, cmd);
			}catch(Exception e){
				appId = "null";
				e.printStackTrace();
			}
			
			// output
			PrintWriter out = response.getWriter();
			out.write(appId==null? "null":appId);
			out.flush();
			
		} else if (METHOD_DEMOGRAPHIC.equals(method)) {
			// demographic recommend

			String userId = request.getSession().getAttribute("userId").toString();
			
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE 
						+ "demographic.py"
						+ " " + userId;
				PythonCaller.execute(conn, cmd);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			List<Label> movieList = PythonCaller.getMovieList(FILE_PATH + FILE_RESULTS, new int[]{1,2});
			JSONObject json = new JSONObject();
			json.put("jsonArray", movieList); 
			
			// output
			PrintWriter out = response.getWriter();
			out.write(json.toString());
			out.flush();
			
		} else if (METHOD_CONTENT_BASED.equals(method)) {
			// Content-based recommend

			String userId = request.getSession().getAttribute("userId").toString();
			
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE 
						+ "contentBased.py"
						+ " " + userId;
				PythonCaller.execute(conn, cmd);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			List<Label> movieList = PythonCaller.getMovieList(FILE_PATH + FILE_RESULTS, new int[]{1,2});
			JSONObject json = new JSONObject();
			json.put("jsonArray", movieList); 
			
			// output
			PrintWriter out = response.getWriter();
			out.write(json.toString());
			out.flush();
			
		} else if (ITEM_BASED_COLLABORATIVE.equals(method)) {
			// itemBasedCollaborative recommend

			String userId = request.getSession().getAttribute("userId").toString();
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE 
						+ "ItemBasedCollaborative.py"
						+ " " + userId;
				PythonCaller.execute(conn, cmd);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			List<Label> movieList = PythonCaller.getMovieList(FILE_PATH + FILE_RESULTS, new int[]{1,2});
			JSONObject json = new JSONObject();
			json.put("jsonArray", movieList); 
			
			// output
			PrintWriter out = response.getWriter();
			out.write(json.toString());
			out.flush();
			
		} else if (USER_BASED_COLLABORATIVE.equals(method)) {
			// userBasedCollaborative recommend

			String userId = request.getSession().getAttribute("userId").toString();
			
			try{
				Connection conn = PythonCaller.login(IP_ADDRESS, PORT, USER_NAME, PASSWORD);
				String cmd = CMD_EXECUTE 
						+ "UserBasedCollaborative.py"
						+ " " + userId;
				PythonCaller.execute(conn, cmd);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			List<Label> movieList = PythonCaller.getMovieList(FILE_PATH + FILE_RESULTS, new int[]{1,2});
			JSONObject json = new JSONObject();
			json.put("jsonArray", movieList); 
			
			// output
			PrintWriter out = response.getWriter();
			out.write(json.toString());
			out.flush();
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
}
