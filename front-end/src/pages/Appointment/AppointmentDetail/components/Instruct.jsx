import React, { useState } from 'react';

export default function Instruct() {
    const [openSections, setOpenSections] = useState({
        preparation: false,
        duringVisit: false,
        afterVisit: false,
        referenceQuestions: false,
    });

    const toggleSection = (section) => {
        setOpenSections((prev) => ({
            ...prev,
            [section]: !prev[section],
        }));
    };

    const sections = [
        {
            id: 'preparation',
            title: 'Chuẩn bị trước khám',
            items: [
                'Nội soi dạ dày: Nhịn ăn 6 giờ; Nhịn uống 2 - 3 giờ trước khi nội soi.',
                'Nội soi đại tràng: Nhịn ăn 8 giờ trước nội soi; Không ăn/uống thực phẩm có màu đỏ hoặc tím, giàu chất xơ trước ngày nội soi.',
                'Những bệnh nhân mắc bệnh hen, tim mạch nên báo với bác sĩ.',
                'Phụ nữ: Thực hiện nội soi sau kỳ kinh nguyệt; báo với bác sĩ nếu đang mang thai hoặc nghi ngờ mang thai.',
                'Chuẩn bị trước câu hỏi để hỏi bác sĩ trong khi khám.',
            ],
        },
        {
            id: 'duringVisit',
            title: 'Trong khi đi khám',
            items: [
                'Dùng câu hỏi đã chuẩn bị trước, hỏi bác sĩ hoặc nhân viên y tế để giải đáp các thắc mắc.',
            ],
        },
        {
            id: 'afterVisit',
            title: 'Sau khi đi khám',
            items: [
                'Tuân thủ dặn dò của bác sĩ.',
                'Chia sẻ trải nghiệm đi khám với cộng đồng.',
            ],
        },
        {
            id: 'referenceQuestions',
            title: 'Câu hỏi tham khảo',
            items: [
                'Nguyên nhân gây bệnh hoặc tình trạng của tôi là gì?',
                'Tình trạng này sẽ kéo dài trong bao lâu và diễn biến thế nào?',
                'Khả năng điều trị khỏi?',
                'Phương pháp điều trị hiệu quả là gì?',
                'Tôi cần tái khám không, trong thời gian bao lâu?',
                'Ưu, nhược điểm của mỗi giải pháp điều trị là gì?',
                'Tôi có được Bảo hiểm y tế chi trả không, mức chi trả bao nhiêu?',
                'Phương pháp hỗ trợ điều trị là gì (chế độ dinh dưỡng, nghỉ ngơi, tập luyện...)?',
            ],
        },
    ];

    return (
        <>
            {/* Tiêu đề */}
            <div className="text-lg font-bold mb-4 bg-gray-200 p-4 rounded-md mt-4">
                Hướng dẫn đi khám
            </div>

            {/* Các phần */}
            {sections.map(({ id, title, items }) => (
                <div className="mb-6" key={id}>
                    <button
                        className="flex items-center font-bold text-teal-600 cursor-pointer justify-start p-3 bg-gray-100 rounded-md w-full"
                        onClick={() => toggleSection(id)}
                        aria-expanded={openSections[id]}
                    >
                        <span
                            className={`mr-2 transition-transform duration-200 ${openSections[id] ? 'rotate-90' : ''
                                }`}
                        >
                            ▶
                        </span>
                        {title}
                    </button>
                    <ul
                        className={`pl-6 list-disc transition-all duration-300 text-left ${openSections[id] ? 'block' : 'hidden'
                            }`}
                    >
                        {items.map((item, idx) => (
                            <li key={idx} className="mb-2">{item}</li>
                        ))}
                    </ul>
                </div>
            ))}
        </>
    );
}
