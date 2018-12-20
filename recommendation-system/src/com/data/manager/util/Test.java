package com.data.manager.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.logging.Logger;

import org.apache.commons.lang.StringUtils;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

public class Test {

    private static String  DEFAULTCHART="UTF-8"; 

	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		Connection conn = Test.login("192.168.247.1", 2222, "koudes2018", "huang2012");
//		String cmd = "cd /mnt/c/Users/JAMES/PycharmProjects/pythonPro2; python3 recommendationSystem1.py";
//		String returnString = Test.execute(conn, cmd);
//		System.out.println(returnString);
//		Test.readFileByLines("C:\\Users\\JAMES\\PycharmProjects\\pythonPro2\\ml-100k\\u.item");
		
		System.out.println(11/3);
		System.out.println(11%3);
	}
	
	// read CSV
    public static void readFileByLines(String fileName) {  
        File file = new File(fileName);  
        BufferedReader reader = null;  
        try {  
            reader = new BufferedReader(new FileReader(file));  
            String tempString = null;  
            int line = 1;  

            while ((tempString = reader.readLine()) != null) {  
                System.out.println("line " + line + ": " + tempString);  
                line++;  
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
    
    /** 
     * ��¼���� 
     * @return 
     *      ��¼�ɹ�����true�����򷵻�false 
     */  
    public static Connection login(String ip,
    						int port,
                            String userName,
                            String userPwd){  

        boolean flg=false;
        Connection conn = null;
        try {  
            conn = new Connection(ip, port);
            conn.connect();//����  
            flg=conn.authenticateWithPassword(userName, userPwd);//��֤  
            if(flg){
                return conn;
            }
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
        return conn;  
    }  

    /** 
     * Զ��ִ��shll�ű��������� 
     * @param cmd 
     *      ����ִ�е����� 
     * @return 
     *      ����ִ����󷵻صĽ��ֵ 
     */  
    public static String execute(Connection conn,String cmd){  
        String result="";  
        try {  
            if(conn !=null){  
                Session session= conn.openSession();//��һ���Ự  
                session.execCommand(cmd);//ִ������
                
                result=processStdout(session.getStdout(),DEFAULTCHART);  
                //���Ϊ�õ���׼���Ϊ�գ�˵���ű�ִ�г�����  
                if(StringUtils.isBlank(result)){
                    result=processStdout(session.getStderr(),DEFAULTCHART);  
                }else{
                }  
                conn.close();  
                session.close();  
            }  
        } catch (IOException e) {
            e.printStackTrace();  
        }  
        return result;  
    }
    /** 
     * �����ű�ִ�з��صĽ���� 
     * @param in ���������� 
     * @param charset ���� 
     * @return 
     *       �Դ��ı��ĸ�ʽ���� 
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
}
