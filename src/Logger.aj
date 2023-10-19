import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import com.bettinghouse.Person;
import com.bettinghouse.User;
public aspect Logger {
	
	File file = new File("Register.txt");
	File file2 = new File("Log.txt");
	Calendar cal;
	User user;
	int x = 0;

	pointcut registrarUsuario(User user, Person person): call(* successfulSignUp(User, Person)) && args(user, person);
	before(User user, Person person) : registrarUsuario(user, person) {
		if (!file.exists()) {
			try {
				file.createNewFile();
			} catch (IOException e) {};
		}
	}

    
    after(User user, Person person) : registrarUsuario(user, person) {
    	this.cal = Calendar.getInstance();
    	try(PrintWriter pw=new PrintWriter(new FileOutputStream(file,true))){
    		pw.println("Usuario registrado: ["+user+"]    Fecha: ["+cal.getTime() + "]");
    		System.out.println("****Usuario ["+user.getNickname()+"] Registrado**** "+cal.getTime());
    	}catch(FileNotFoundException e){
    		System.out.println(e.getMessage());
    	}    
    }

    pointcut sesionEventos(User user) : (execution(* effectiveLogIn(User)) || execution(* effectiveLogOut(User))) && args(user);
    before(User user) : sesionEventos(user) {
    	if (!file2.exists()) {
    		try {
    			file2.createNewFile();
    		} catch (IOException e) {}   		
    	}   	
    }
    after(User user) : sesionEventos(user) { 
    	if (x == 0) {    	
	    	this.cal = Calendar.getInstance();
	    	try(PrintWriter pw=new PrintWriter(new FileOutputStream(file2,true))){
	    		pw.println("Sesion iniciado por Usuario: ["+user.getNickname()+"]    Fecha: ["+cal.getTime()+"]");
	    		System.out.println("****Usuario ["+user.getNickname()+"] Ha iniciado sesión**** "+cal.getTime());
	    	}catch(FileNotFoundException e){
	    		System.out.println(e.getMessage());
	    	}
	    	x++;
    	} else if (x == 1) {
    		this.cal = Calendar.getInstance();
	    	try(PrintWriter pw=new PrintWriter(new FileOutputStream(file2,true))){
	    		pw.println("Sesion cerrada por Usuario: ["+user.getNickname()+"]    Fecha: ["+cal.getTime()+"]");
	    		System.out.println("****Usuario ["+user.getNickname()+"] Ha cerrado sesión**** "+cal.getTime());
	    	}catch(FileNotFoundException e){
	    		System.out.println(e.getMessage());
	    	}
	    	x--;
    	}
    }
}