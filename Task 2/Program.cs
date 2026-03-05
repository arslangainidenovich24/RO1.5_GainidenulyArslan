class Program
{
    static void Main()
    {
        // Exercise 1
        Console.WriteLine("Exercise 1:");
        Console.Write("Enter first number: ");
        int a = Convert.ToInt32(Console.ReadLine());

        Console.Write("Enter second number: ");
        int b = Convert.ToInt32(Console.ReadLine());

        if (a == b)
            Console.WriteLine("The numbers are equal");
        else if (a > b)
            Console.WriteLine("The first number is greater than the second");
        else
            Console.WriteLine("The first number is less than the second");

        Console.WriteLine();


        // Exercise 2
        Console.WriteLine("Exercise 2:");
        Console.Write("Enter number: ");
        int number = Convert.ToInt32(Console.ReadLine());

        if (number > 5 && number < 10)
            Console.WriteLine("The number is greater than 5 and less than 10");
        else
            Console.WriteLine("Unknown number");

        Console.WriteLine();


        // Exercise 3
        Console.WriteLine("Exercise 3:");
        Console.Write("Enter number: ");
        int num = Convert.ToInt32(Console.ReadLine());

        if (num == 5 || num == 10)
            Console.WriteLine("The number is either 5 or 10");
        else
            Console.WriteLine("Unknown number");

        Console.WriteLine();


        // Exercise 4
        Console.WriteLine("Exercise 4:");
        Console.Write("Enter deposit amount: ");
        double deposit = Convert.ToDouble(Console.ReadLine());

        double percent;

        if (deposit < 100)
            percent = 0.05;
        else if (deposit <= 200)
            percent = 0.07;
        else
            percent = 0.10;

        double result = deposit + (deposit * percent);
        Console.WriteLine("Amount with interest: " + result);

        Console.WriteLine();


        // Exercise 5
        Console.WriteLine("Exercise 5:");
        Console.Write("Enter deposit amount: ");
        double deposit2 = Convert.ToDouble(Console.ReadLine());

        double percent2;

        if (deposit2 < 100)
            percent2 = 0.05;
        else if (deposit2 <= 200)
            percent2 = 0.07;
        else
            percent2 = 0.10;

        double result2 = deposit2 + (deposit2 * percent2) + 15;
        Console.WriteLine("Amount with interest and bonus: " + result2);

        Console.WriteLine();


        // Exercise 6
        Console.WriteLine("Exercise 6:");
        Console.WriteLine("Enter operation number:");
        Console.WriteLine("1. Addition");
        Console.WriteLine("2. Subtraction");
        Console.WriteLine("3. Multiplication");

        int operation = Convert.ToInt32(Console.ReadLine());

        switch (operation)
        {
            case 1:
                Console.WriteLine("Addition");
                break;
            case 2:
                Console.WriteLine("Subtraction");
                break;
            case 3:
                Console.WriteLine("Multiplication");
                break;
            default:
                Console.WriteLine("Operation is undefined");
                break;
        }

        Console.WriteLine();


        // Exercise 7
        Console.WriteLine("Exercise 7:");

        Console.Write("Enter operation number: ");
        int op = Convert.ToInt32(Console.ReadLine());

        Console.Write("Enter first number: ");
        int x = Convert.ToInt32(Console.ReadLine());

        Console.Write("Enter second number: ");
        int y = Convert.ToInt32(Console.ReadLine());

        switch (op)
        {
            case 1:
                Console.WriteLine("Result: " + (x + y));
                break;
            case 2:
                Console.WriteLine("Result: " + (x - y));
                break;
            case 3:
                Console.WriteLine("Result: " + (x * y));
                break;
            default:
                Console.WriteLine("Operation is undefined");
                break;
        }
    }
}