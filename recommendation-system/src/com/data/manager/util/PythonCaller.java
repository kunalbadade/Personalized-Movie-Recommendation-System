package com.data.manager.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.data.manager.entity.Label;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

public class PythonCaller {

    private static String  DEFAULTCHART="ISO-8859-1"; 

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Connection conn = PythonCaller.login("192.168.247.1", 2222, "koudes2018", "huang2012");
		String cmd = "cd /mnt/c/Users/JAMES/PycharmProjects/pythonPro2; python3 recommendationSystem1.py";
		String returnString = PythonCaller.execute(conn, cmd);
		System.out.println(returnString);
	}
	
    /** 
     * login linux host
     * @return 
     *      success:true fail:false
     */  
    public static Connection login(String ip,
    						int port,
                            String userName,
                            String userPwd){  

        boolean flg=false;
        Connection conn = null;
        try {  
            conn = new Connection(ip, port);
            conn.connect();//connect
            flg=conn.authenticateWithPassword(userName, userPwd);//valify
            if(flg){
                return conn;
            }
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
        return conn;  
    }  

    /** 
     * execute shell script or command
     * @param cmd 
     *      command
     * @return 
     *      result
     */  
    public static String execute(Connection conn,String cmd){  
        String result = "";  
        try {  
            if(conn !=null){  
                Session session= conn.openSession();
                session.execCommand(cmd);
                
                result=processStdout(session.getStdout(),DEFAULTCHART);  
                // if get a null result, it means the execution was wrong
                if(StringUtils.isBlank(result)){
                    result=processStdout(session.getStderr(),DEFAULTCHART);  
                }else{
                }
                session.close();  
                conn.close();  

            }  
        } catch (IOException e) {
            e.printStackTrace();  
        }  
        return result;  
    }
    /** 
     * print out the result from python
     * @param in
     * @param charset
     * @return 
     *       String
     */  
     private static String processStdout(InputStream in, String charset){  
         InputStream  stdout = new StreamGobbler(in);  
         StringBuffer buffer = new StringBuffer();
         try {  
             BufferedReader br = new BufferedReader(new InputStreamReader(stdout,charset));  
             String line=null;  
             while((line=br.readLine()) != null){  
                 buffer.append(line+"\n");  
             }  
         } catch (UnsupportedEncodingException e) { 
             e.printStackTrace();  
         } catch (IOException e) {
             e.printStackTrace();  
         }  
         return buffer.toString();  
     }
     
     // read CSV
     public static List<Label> getMovieList(String fileName, int[] columns) {  
         File file = new File(fileName);  
         BufferedReader reader = null;  
         List<Label> checkboxes = new ArrayList<Label>();
         try {  
             reader = new BufferedReader(new FileReader(file));  
             String tempString = null;  

             while ((tempString = reader.readLine()) != null) {  
                 String[] strings = tempString.split("\\|");
                 checkboxes.add(new Label(strings[columns[0]], strings[columns[1]]));
             }  
             reader.close();  
         } catch (IOException e) {  
             e.printStackTrace();  
         } finally {  
             if (reader != null) {  
                 try {  
                     reader.close();  
                 } catch (IOException e1) {  
                 }  
             }  
         }  
         
         return checkboxes;
     }  
     
     // read CSV
     public static void checkMovies(String fileName, int[] columns, List<Label> movieList, String userId) {  
         File file = new File(fileName);  
         BufferedReader reader = null;  
         try {  
             reader = new BufferedReader(new FileReader(file));  
             String tempString = null;  

             while ((tempString = reader.readLine()) != null) {  
                 String[] strings = tempString.split("\t");
                 String lineUserId = strings[columns[0]];
                 String lineMovieId = strings[columns[1]];
                 
                 if (userId.equals(lineUserId)) {
                	 movieList.get(Integer.parseInt(lineMovieId)-1).setIfChecked(lineMovieId);
                 }
             }  
             reader.close();  
         } catch (IOException e) {  
             e.printStackTrace();  
         } finally {  
             if (reader != null) {  
                 try {  
                     reader.close();  
                 } catch (IOException e1) {  
                 }  
             }  
         }  
         
     }  
     
}
