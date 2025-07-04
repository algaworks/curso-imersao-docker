public class MyApp {
    public static void main(String[] args) {
        System.out.println("Hello from MyApp!");
        System.out.println("Esta é uma aplicação Java simples executando no Docker");
        
        if (args.length > 0) {
            System.out.println("Argumentos recebidos:");
            for (int i = 0; i < args.length; i++) {
                System.out.println("  Arg " + i + ": " + args[i]);
            }
        }
        
        // Exibe informações do sistema
        System.out.println("\nInformações do Sistema:");
        System.out.println("Java Version: " + System.getProperty("java.version"));
        System.out.println("OS Name: " + System.getProperty("os.name"));
        System.out.println("OS Version: " + System.getProperty("os.version"));
        System.out.println("User Name: " + System.getProperty("user.name"));
        System.out.println("Working Directory: " + System.getProperty("user.dir"));
    }
}
