# include <iostream>
# include <limits>

int ASubDobroB(int a, int b){

	b += b;
	if(a > b)
		return a-b;
	else
		return b-a;
}


int main(int* argc, char** argv){

	int a = 10, b = 5;
	int c = a;
	for(int i = 0; i < b; i++){
		for(int j = 0; j < a; j++){
			c += c;
			if(c == 80)
				break;
		}
		if(c == 80)
			break;
	}
	int d = ASubDobroB(c, a);

	int e = std::numeric_limits<int>::max(); // não tratar isso como função, só é um jeito prático de inserir o maior numero inteiro em "e".
	e = e + 1; // Supostamente causa exceção, mas o C++ deve lidar com isso.

	return 0;
}