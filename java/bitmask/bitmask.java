import java.util.regex.Pattern;

public class bitmask {
    // bitmaskについて考える
    // ip と bitmask　から　デフォ毛を出す
    public static void main(String[] args) {
        //受付
        String ip = args[0];
        String mask = args[1];
        System.out.println("ip:" + ip);
        System.out.println("bitmask:" + mask);
        
        //出力
        System.out.print("defaultGW:");
        int[] defaultGW = showDefaultGW(ip,mask);
        for (int i = 0; i < 4; i++) {
            System.out.print(defaultGW[i]);
            if (i != 3) {
                System.out.print(".");
            }else{
                System.out.println();
            }
        }
    }

    public static int[] showDefaultGW(String ip,String mask) {
        String[] ipArr = new String[4];
        String[] maskArr = new String[4];
        int[] defaultGW = new int[4];

        ipArr =  ip.split(Pattern.quote("."));
        maskArr = mask.split(Pattern.quote("."));
        
        //AND演算によって…
        //マスクしている部分は被マスクのBITと同じ値
        //マスクしていない部分は全て0
        for (int i = 0; i < 4; i++) {
            defaultGW[i] = (Integer.parseInt(ipArr[i]) & Integer.parseInt(maskArr[i]));
        }
        defaultGW[3]++;
        return defaultGW;
    }
}

