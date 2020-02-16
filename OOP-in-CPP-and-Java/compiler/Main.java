import java.util.*;
import java.io.*;
import java.nio.channels.FileChannel;

class Main {
    public static String funcName = "main";
    public static int PC = 0;
    public static int offsCount = 0;
    public static List<String[]> progList = new Vector<String[]>();
    public static Hashtable<String, StackObj> symTable = new Hashtable<String, StackObj>();

    public static FileOutputStream fs = null;
    public static FileChannel fc = null;

    public static void main(String[] args) {
        if(args.length < 2) {
        System.out.println("Insufficient arguments");
            return;
        }
        FileInputStream fin = null;
        try {
            fin = new FileInputStream(args[0]);
        }
        catch (Exception e) {
            System.out.println(e);
        }

        try {
            fs = new FileOutputStream(args[1]);
            fc = fs.getChannel();
        }
        catch(FileNotFoundException fnfe) {
            System.out.println(fnfe);
            return;
        }

        try {
            read_lines(fin);
            for(int i = 0; i < progList.size(); i++) {
                parse_line(progList.get(i));
            }
        }
        catch(Exception e) {
            System.out.println(e);
            return;
        }
        
        try {
            fc.close();
            fs.close();
        }
        catch(IOException e) {
            System.out.println(e);
            return;
        }
    }

    static void read_lines(FileInputStream fin) throws Exception {
        BufferedReader buffreader = new BufferedReader(new InputStreamReader(fin));
        String newline = null;
        while((newline = buffreader.readLine()) != null) {
            newline = newline.trim();
            String args[] = newline.split(" +");
            if(!newline.isEmpty() && newline.charAt(0) != '/') {
                progList.add(args);
                update_symTable(args);
            }
        }
    }

    static void update_symTable(String[] args) throws Exception {
        StackObj obj = new StackObj();
        switch(args[0]) {
            case "decl" :   obj.offs = offsCount++;
                            obj.val = 0;
                            symTable.put(funcName + args[1], obj);
                            PC += 5;
                break;
            case "lab"  :   obj.offs = 0;
                            obj.val = PC;
                            symTable.put(funcName + args[1], obj);
                break;
            case "subr" :   funcName = args[2];
                            obj.offs = PC;
                            obj.val = Integer.parseInt(args[1]);
                            symTable.put(args[2], obj);
                            PC += 17;
                break;
            case "swp"  :
            case "add"  :
            case "sub"  :
            case "mul"  :
            case "div"  :
            case "cmpe" :
            case "cmplt":
            case "cmpgt":   PC++;
                break;
            case "printv":
            case "ret"  :   PC += 7;
                break;
            case "jmp"  :
            case "jmpc" :
            case "popm" :
            case "popv" :
            case "pushv":
            case "printi":  PC += 6;
                break;
            case "pushi":   PC += 5;
                break;
            case "poke" :
            case "peek" :   PC += 11;
        }
    }

    static void parse_line(String[] args) throws Exception {
        switch(args[0]) {
            case "decl"     : Stmt.decl(args);
                break;
            case "lab"      : Stmt.lab(args);
                break;
            case "subr"     : Stmt.subr(args);
                break;
            case "printi"   : Stmt.printi(args);
                break;
            case "printv"   : Stmt.printv(args);
                break;
            case "jmp"      : Stmt.jmp(args);
                break;
            case "jmpc"     : Stmt.jmpc(args);
                break;
            case "cmpe"     : Stmt.cmpe(args);
                break;
            case "cmplt"    : Stmt.cmplt(args);
                break;
            case "cmpgt"    : Stmt.cmpgt(args);
                break;
            case "pushi"    : Stmt.pushi(args);
                break;
            case "pushv"    : Stmt.pushv(args);
                break;
            case "popm"     : Stmt.popm(args);
                break;
            case "popv"     : Stmt.popv(args);
                break;
            case "peek"     : Stmt.peek(args);
                break;
            case "poke"     : Stmt.poke(args);
                break;
            case "swp"      : Stmt.swp(args);
                break;
            case "add"      : Stmt.add(args);
                break;
            case "sub"      : Stmt.sub(args);
                break;
            case "mul"      : Stmt.mul(args);
                break;
            case "div"      : Stmt.div(args);
                break;
            case "ret"      : Stmt.ret(args);
                break;
            default         :System.out.println("Invalid command received: " + args[0]);
        }
    }
}