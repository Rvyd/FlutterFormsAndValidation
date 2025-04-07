import 'package:flutter/material.dart';
//NOTE; BS438 Uygulama ödevi  Erciyes Üniversitesi/Mühendislik Fakültesi/ Bilgisayar Mühendisliği/MOBILE APPLICATION DEVELOPMENT/YRD.DOÇ. DR. FEHİM KÖYLÜ
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding + Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: OnboardingScreen(),
    );
  }
}
//kullanıcıların onboarding sayfalarına geçiş yapmasını sağlamak için PageController kullanır ve son sayfada bir buton gösterir.
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  Widget buildPage({   //onboarding sayfalarının genel şablonun nasıl olacağını belirledik.
    //Hangi değişkenlerin var olduğunu tanımladık.
    required String title,
    required String subtitle,
    String? imagePath,
    IconData? icon,
    String? note,
    bool isLastPage = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Görsel (eğer varsa) belirtilen özellikler ile gösterilecek
        if (imagePath != null)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Image.asset(
              imagePath,
              height: 200,
              width: 200,
            ),
          ),

        // İkon (eğer varsa) belirtilen özellikler ile gösterilecek
        if (icon != null)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Icon(icon, size:40, color: Colors.indigo),
          ),

        SizedBox(height: 30),

        // Başlık belirtilen özellikler ile gösterilecek
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),

        SizedBox(height: 10),

        // Açıklama belirtilen özellikler ile gösterilecek
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        // Eğer son sayfa ise, altına not ekleyecek
        if (isLastPage)
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Not: Okul mail adresiniz ve şifresiyle giriş yapabilirsiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent.shade700),
              ),
            ],
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) { //Onboarding içeriğinin özelleştirilmesi
    return Scaffold(
      appBar: AppBar(
        title: Text("BS438 Uygulama Ödevi  "),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            buildPage(
              title: "Hoş Geldin",
              subtitle: "BS 438 Mobile Application Development dersine hoş geldin!",
              icon: Icons.waving_hand,
              imagePath: "assets/images/welcomelogo.png",
            ),
            buildPage(
              title: "Dr. Öğr. Üyesi Fehim KÖYLÜ anlatımıyla",
              subtitle: "Dart temelleri ile mobil dünyasını keşfet.",
              icon: Icons.touch_app,
              imagePath: "assets/images/dart.png",
            ),
            buildPage(
              title: "Haydi Başlayalım!",
              subtitle: "Giriş yaparak devam et.",
              icon: Icons.login,
              isLastPage: true,
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage  //Son sayfaya ulaşıldığında başla butonu ile giriş sayfasına yönlendirilip onboarding sonlanıyor.
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
          child: Text("Başla", style: TextStyle(color: Colors.white)),
        ),
      )
          : Container(  //Onboarding içeriğini atlama veya tek tek ilermek için
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _controller.jumpToPage(2),
              child: Text("Atla"),
            ),

            TextButton(
              onPressed: () => _controller.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              child: Text("İleri"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget { //Giriş kısımının kontrolü
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();  //default bir mail ve şifre tanımlandı. Bu kısım db'dan da alınabilir.
      String password = passwordController.text;

      if (email == '1030521038@erciyes.edu.tr' && password == '123456') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giriş başarılı!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("E-posta veya şifre yanlış")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {  //Login sayfası tasarımı
    return Scaffold(
      appBar: AppBar(
        title: Text("BS438 Uygulama Ödevi  "),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            // Başlık
            Text(
              "Hoşgeldiniz!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // E-posta Alanı
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-posta",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.contains('@') ? null : "Geçerli bir e-posta girin",  //belirtilen karakterin mail kısmında olup olmadıdığını kontrol ettim.
                  ),
                  SizedBox(height: 20),
                  // Şifre Alanı
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.length >= 6 ? null : "En az 6 karakter olmalı",  //Şifreye karakter sınırı getirdim.
                  ),
                  SizedBox(height: 30),
                  // Giriş Yap Butonu
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Giriş Yap", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
