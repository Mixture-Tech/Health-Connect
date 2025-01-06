import React from "react";
import Container from "@mui/material/Container";
import Typography from "@mui/material/Typography";
import Link from "@mui/material/Link";
import { Box } from "@mui/material";

const logoStyle = {
    width: '140px',
    height: 'auto',
    cursor: 'pointer',
};

export default function Footer() {
    return (
        <Box
            className="bg-blue-50"
            sx={{ p: 6 }}
        >
            <Container maxWidth="sm">
                <Box
                    sx={{
                        display: 'flex',
                        justifyContent: 'center',
                        alignItems: 'center',
                        px: 0,
                    }}
                >
                    <img
                        src="https://assets-global.website-files.com/61ed56ae9da9fd7e0ef0a967/61f12e6faf73568658154dae_SitemarkDefault.svg"
                        style={logoStyle}
                        alt="logo of sitemark"
                    />
                </Box>
                <Typography variant="body2" color="text.secondary" align="center">
                    {"Copyright © "}
                    <Link color="inherit" href="https://your-website.com/">
                        Mixture Team
                    </Link>
                    {" "}
                    {new Date().getFullYear()}
                    {"."}
                </Typography>
            </Container>
        </Box>
    );
}