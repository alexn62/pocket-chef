import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../Constants/Spacing.dart';
import '../../Constants/Themes.dart';
import '../../Models/Instruction.dart';

class CookingModeCarousel extends StatefulWidget {
  final List<Instruction> items;
  final Function() toggle;
  const CookingModeCarousel(
      {Key? key, required this.toggle, required this.items})
      : super(key: key);

  @override
  State<CookingModeCarousel> createState() => _CookingModeCarouselState();
}

class _CookingModeCarouselState extends State<CookingModeCarousel> {
  final CarouselController carouselController = CarouselController();
  toggleDone(Instruction instruction) {
    Instruction item =
        widget.items.firstWhere((element) => element == instruction);
    item.done = !item.done;
    if (item.done && item != widget.items.last) {
      carouselController.animateToPage(widget.items.indexOf(item) + 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: -10),
          child: GestureDetector(
            onTap: widget.toggle,
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .5,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: .75),
                items: widget.items
                    .map(
                      (e) => Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            carouselController
                                .animateToPage(widget.items.indexOf(e));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2))
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                              .withOpacity(0.1),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary),
                                          borderRadius:
                                              BorderRadius.circular(60 / 2),
                                        ),
                                        child: Center(
                                          child: Text(
                                              (widget.items.indexOf(e) + 1)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  fontSize: 21)),
                                        )),
                                  ),
                                  vRegularSpace,
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        e.description,
                                        style: const TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  vRegularSpace,
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () => toggleDone(e),
                                      child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: e.done
                                                ? goodColor.withOpacity(.1)
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                            border: Border.all(
                                                color: e.done
                                                    ? goodColor
                                                    : Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.5)),
                                            borderRadius:
                                                BorderRadius.circular(60 / 2),
                                          ),
                                          child: Center(
                                              child: Icon(
                                            Icons.check,
                                            size: 30,
                                            color: e.done
                                                ? goodColor
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.3),
                                          ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
