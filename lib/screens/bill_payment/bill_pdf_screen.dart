import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class BillPdfScreen extends StatefulWidget {
  final BillPaymentAmounts? billPaymentAmounts;
  const BillPdfScreen({
    Key? key,
    required this.billPaymentAmounts,
  }) : super(key: key);

  @override
  _BillPdfScreenState createState() => _BillPdfScreenState();
}

class _BillPdfScreenState extends State<BillPdfScreen> {
  // static final int _initialPage = 2;
  // int _actualPageNumber = _initialPage, _allPagesCount = 0;
  // bool isSampleDoc = true;
  // late PdfController _pdfController;
  PageController controller = PageController();

  late PDFDocument doc;
  bool isLoading = true;

  @override
  void initState() {
    // _pdfController = PdfController(
    //   document: PdfDocument.openFile(widget.billPaymentAmounts!.bill!.bill!),
    //   initialPage: _initialPage,
    // );

    getPdf();

    super.initState();
  }

  getPdf() async {
    doc = await PDFDocument.fromURL(widget.billPaymentAmounts!.bill!.bill!);
    setState(() {
      isLoading = false;
    });
  }

  // @override
  // void dispose() {
  //   _pdfController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Bill Payment",
          style: kBlackLargeStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: !isLoading
                  ? PDFViewer(
                      document: doc,
                      lazyLoad: true,
                      controller: controller,
                    )
                  : const Center(child: CircularProgressIndicator())),
          // Expanded(
          //   child: PdfView(
          //     documentLoader: const Center(child: CircularProgressIndicator()),
          //     pageLoader: const Center(child: CircularProgressIndicator()),
          //     controller: _pdfController,
          //     onDocumentLoaded: (document) {
          //       setState(() {
          //         _allPagesCount = document.pagesCount;
          //       });
          //     },
          //     onPageChanged: (page) {
          //       setState(() {
          //         _actualPageNumber = page;
          //       });
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Download',
                    width: false,
                    onTap: () {
                      // Get.back();
                    },
                    widthSize: Get.width * 0.9,
                    buttonState: ButtonState.idle,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GradientButton(
                    text: 'Share',
                    width: false,
                    onTap: () {
                      Get.back();
                    },
                    widthSize: Get.width * 0.9,
                    buttonState: ButtonState.idle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
