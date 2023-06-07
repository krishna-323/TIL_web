import 'package:flutter/material.dart';

class KpiCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String subTitle2;
  final IconData icon;
  const KpiCard({ required this.title,required this.subTitle,required this.subTitle2,required this.icon,Key? key}) : super(key: key);

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        height: 130,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 20),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 55,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Icon(Icons.account_circle,color: Colors.white,size: 30),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text(widget.title,overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(child: Text(widget.subTitle,overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                              Flexible(
                                child: Row(
                                  children: [
                                    const Flexible(child: Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                    Flexible(child: Text(widget.subTitle2,overflow:TextOverflow.ellipsis,maxLines: 1 ,style: const TextStyle(color: Colors.green,fontSize: 12,))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Container(
              height: 40,decoration: BoxDecoration(
              color: const Color(0xffF9FAFB),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(
                width: 3,
                color: Colors.transparent,
                style: BorderStyle.solid,
              ),
            ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                    child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
