<%@ page import="java.io.*,java.util.*, javax.servlet.*, java.text.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%
   File file ;
   int maxFileSizeMax = 100000 * 100000;         // MAx FILE SIZE YOU WISH TO KEEP //
   int maxMemSize = 100000 * 100000;          // MAx MEMORY SIZE THAT WILL BE STORED ON THE SERVER //

   ServletContext context = pageContext.getServletContext();
   String filePath = context.getInitParameter("file-upload");

   String contentType = request.getContentType();

   if ((contentType.indexOf("multipart/form-data") >= 0)) {

      DiskFileItemFactory factory = new DiskFileItemFactory();
      factory.setSizeThreshold(maxMemSize);

      // Location to save data that is larger than maxMemSize.
      factory.setRepository(new File("E:\\LocationOfTheFile\\"));

      // File upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);
      upload.setSizeMax(maxFileSize);
      try{ 

         // Request Parsing to get file items
         List fileItems = upload.parseRequest(request);

         // Processing the uploaded items
         Iterator i = fileItems.iterator();
         String fileName2 = "xyz";

         while ( i.hasNext () ) 
         {
            FileItem fileItem = (FileItem)i.next();
            if ( !fileItem.isFormField () )	
            {

            // Getting file parameters
            String fieldName = fileItem.getFieldName();
            String fileName = fileItem.getName();
            fileName2=fileName;
            boolean isInMemory = fileItem.isInMemory();
            long sizeInBytes = fileItem.getSize();

            // File writing
            if( fileName.lastIndexOf("\\") >= 0 ){
            file = new File( filePath + 
            fileName.substring( fileName.lastIndexOf("\\")));
            }else{
            file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\")+1));
            }
            fileItem.write(file);

            out.println("Following file is uploaded" + filePath + fileName);
            }
         }

         // CODE TO RENAME THE FILE USING CMD
 
         StringBuilder command = new StringBuilder("cmd /c cd E:\\LocationOfTheFile & ren \""+fileName2+"\" renamedfile.txt"); 
         Process process = Runtime.getRuntime().exec(command.toString());
         process.waitFor();

      }catch(Exception ex) {
         System.out.println(ex);
      }
   }else{
      out.println("<html>");
      out.println("<body>");
      out.println("<p>File was not uploaded</p>"); 
      out.println("</body>");
      out.println("</html>");
   }
%>