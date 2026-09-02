import '../../Constants/Library.dart';
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<dynamic> tr =[
    {"title":"Feature 01",
      "content":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna"},
    {"title":"Feature 02",
      "content":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna"},
    {"title":"Feature 03",
      "content":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna"}];

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: PageView.builder(
            itemCount: 3,
            onPageChanged: (value){
              setState(() {
                currentPageIndex = value;
              });
            },
            itemBuilder: (context,index){
              return Container(
                width: context.screenWidth,
                height: context.screenHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment
                        .centerLeft,
                    end: Alignment
                        .centerRight,
                    colors: [
                      Color(0xffe0659b),
                      Color(0xff8b4de6)
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: context.screenWidth,
                      height: context.screenHeight * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            ir,
                          ),
                          fit: BoxFit.cover
                        )
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(onPressed: (){
                              Get.offAll(()=> const LoginPage());
                            },
                            child: TextWidget("Skip",color: Colors.white,fontSize: 25,

                              fontWeight: FontWeight.w700,),),

                          ).pLTRB(10.0, 40.0, 20.0, 10.0),

                          Image.asset(s1),
                          10.heightBox,
                          Image.asset(kr),
                        ],
                      ),
                    ),
                    20.heightBox,
                    Expanded(
                      child: Column(
                       
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(tr[index]['title'],
                            color: Colors.white,
                            fontSize: 36,

                            fontWeight: FontWeight.w700,),
                          20.heightBox,
                          SizedBox(
                            width: context.screenWidth,
                            child: TextWidget(tr[index]['content'],
                              color: Colors.white,
                              fontSize: 15,

                              fontWeight: FontWeight.w700,maxLines: 20,),
                          ),
                        ],
                      ).p16(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3,
                                (index) => Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:  index == currentPageIndex ?
                                    Colors.white : Colors.white24),
                                ).p8())
                      ).p16(),
                    ),
                  ],
                ),
              );
            },),
      ),
    );
  }
}
