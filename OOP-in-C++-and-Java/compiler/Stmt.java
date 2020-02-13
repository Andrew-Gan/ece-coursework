import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class Stmt {
    static void genCode(int out, boolean isStmt) {
        try{
            if(isStmt) {Main.fs.write(out);Main.PC++;}
            else{
                ByteBuffer buff = ByteBuffer.allocate(4);
                buff.order(ByteOrder.LITTLE_ENDIAN);
                buff.putInt(out);
                buff.flip();
                Main.fc.write(buff);
                Main.PC+=4;
            }
        }
        catch(Exception e) {
            System.out.println(e);
        }
    }
    public static void decl(String args[]) {
        genCode(70, true);
        genCode(0, false);
    }
    public static void lab(String args[]) {}
    public static void subr(String args[]) {
        genCode(70, true);
        genCode(16, false);
        genCode(70, true);
        genCode(17, false);
        genCode(70, true);
        genCode(1, false);
        genCode(44, true);
        genCode(0, true);
    }
    public static void printi(String args[]) {
        genCode(70, true);
        genCode(Integer.parseInt(args[1]), false);
        genCode(146, true);
    }
    public static void printv(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[1]).offs, false);
        genCode(74, true);
        genCode(146, true);
    }
    public static void jmp(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[1]).val, false);
        genCode(36, true);
    }
    public static void jmpc(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[1]).val, false);
        genCode(40, true);
    }
    public static void cmpe(String args[]) {
        genCode(132, true);
    }
    public static void cmplt(String args[]) {
        genCode(136, true);
    }
    public static void cmpgt(String args[]) {
        genCode(140, true);
    }
    public static void pushi(String args[]) {
        genCode(70, true);
        genCode(Integer.parseInt(args[1]), false);
    }
    public static void pushv(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[1]).offs, false);
        genCode(74, true);
    }
    public static void popm(String args[]) {
        genCode(70, true);
        genCode(Integer.parseInt(args[1]), false);
        genCode(76, true);
    }
    public static void popv(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[1]).offs, false);
        genCode(80, true);
    }
    public static void peek(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[1]).offs, false);
        genCode(70, true);
        genCode(Integer.parseInt(args[2]), false);
        genCode(86, true);
    }
    public static void poke(String args[]) {
        genCode(70, true);
        genCode(Main.symTable.get(Main.funcName + args[2]).offs, false);
        genCode(70, true);
        genCode(Integer.parseInt(args[1]), false);
        genCode(90, true);
    }
    public static void swp(String args[]) {
        genCode(94, true);
    }
    public static void add(String args[]) {
        genCode(100, true);
    }
    public static void sub(String args[]) {
        genCode(104, true);
    }
    public static void mul(String args[]) {
        genCode(108, true);
    }
    public static void div(String args[]) {
        genCode(112, true);
    }
    public static void ret(String args[]) {
        genCode(70, true);
        genCode(0, false);
        genCode(77, true);
        genCode(48, true);
    }
}